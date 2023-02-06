locals {
  tags                 = merge(var.global_tags, var.tags)
  aws_ecr_url          = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
  container_definition = <<DEFINITION
[
    {   "name": "testapp",
        "essential": true,
        "image": "${module.repo.repo.repository_url}:${var.image_tag}",
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${module.app_log_group.log_group_name}",
                "awslogs-region": "${var.region}",
                "awslogs-stream-prefix": "testapp"
            }
          },
        "portMappings": [
            {
                "containerPort": 3000,
                "hostPort": 3000,
                "protocol": "tcp"
            }
        ],
        "secrets": [
          {
            "name": "POSTGRES_HOST",
            "valueFrom": "${module.rds_posrgres_cred.secret.arn}"
          },
          {
            "name": "POSTGRES_PASSWORD",
            "valueFrom": "${module.rds_postgres_endpoint.secret.arn}"
          }
        ],
        "environment": [
          {
            "name": "POSTGRES_DB",
            "value": "postgres"
          },
          {
            "name": "POSTGRES_USER",
            "value": "postgres"
          }
        ]
    }
]
DEFINITION
}

data "aws_caller_identity" "current" {}

data "aws_ecr_authorization_token" "token" {}

data "aws_iam_policy_document" "policy_document_ecr_access" {
  statement {
    actions = [
      "ecr:*"
    ]
    effect = "Allow"
    resources = [
      "*"
    ]

  }
}

data "aws_iam_policy_document" "policy_document_cwlogs" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "policy_document_secret_manager_access" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }
}


### Generate a random password for RDS DB Instance
resource "random_password" "postgres_db_password" {
  length  = 16
  upper   = true
  lower   = true
  numeric = true
  special = false
}

### Create VPC
module "vpc" {
  source = "../modules/vpc/vpc"

  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
  tags     = local.tags
}

### Create Public Subnets
module "public_subnets" {
  source = "../modules/vpc/subnets"

  region                  = var.region
  vpc_azs                 = var.vpc_azs
  vpc_id                  = module.vpc.vpc.id
  vpc_name                = var.vpc_name
  subnets_cidr            = var.pub_subnets_cidr
  subnet_type             = var.pub_subnet_type
  map_public_ip_on_launch = var.pub_sub_map_public_ip_on_launch
  tags                    = local.tags
}

### Create Private Subnets
module "private_subnets" {
  source = "../modules/vpc/subnets"

  region       = var.region
  vpc_azs      = var.vpc_azs
  vpc_id       = module.vpc.vpc.id
  vpc_name     = var.vpc_name
  subnets_cidr = var.priv_subnets_cidr
  subnet_type  = var.priv_subnet_type
  tags         = local.tags
}

### Create DB Subnets
module "db_subnets" {
  source = "../modules/vpc/subnets"

  region       = var.region
  vpc_azs      = var.vpc_azs
  vpc_id       = module.vpc.vpc.id
  vpc_name     = var.vpc_name
  subnets_cidr = var.db_subnets_cidr
  subnet_type  = var.db_subnet_type
  tags         = local.tags
}

### Create NAT & Internet Gateways
module "gateways" {
  source = "../modules/vpc/gateways"

  vpc_name          = var.vpc_name
  vpc_id            = module.vpc.vpc.id
  vpc_azs           = var.vpc_azs
  num_az            = var.num_az
  public_subnet_ids = module.public_subnets.subnet_ids
  tags              = local.tags
}

### Create Route Tables
module "routes" {
  source = "../modules/vpc/routes"

  vpc_id             = module.vpc.vpc.id
  vpc_name           = var.vpc_name
  vpc_azs            = var.vpc_azs
  igw_id             = module.gateways.igw_id
  ngw_id             = module.gateways.ngw_id
  num_az             = var.num_az
  public_subnet_ids  = module.public_subnets.subnet_ids
  private_subnet_ids = module.private_subnets.subnet_ids
  db_subnet_ids      = module.db_subnets.subnet_ids
  tags               = local.tags
}

### Enable VPC Flow Logs for the VPC
module "vpc_flow_logs" {
  source = "../modules/vpc/vpc_flow"

  vpc_id           = module.vpc.vpc.id
  vpc_flow_iam_set = var.vpc_flow_iam_set
  vpc_name         = var.vpc_name
  tags             = local.tags
}

### Create Security Group for the Application Load Balancer
module "alb_security_group" {
  source = "../modules/security_group"

  security_group = {
    name        = "Load Balancer SG"
    description = "Load Balancer SG"
    vpc_id      = module.vpc.vpc.id
    cidr_block_ingress_rules = [
      {
        from_port   = 80,
        to_port     = 80,
        protocol    = "tcp",
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 443,
        to_port     = 443,
        protocol    = "tcp",
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    cidr_block_egress_rules = [
      {
        from_port   = 0,
        to_port     = 0,
        protocol    = "-1",
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
  tags = local.tags
}

### Create Security Group for Application ECS Tasks
module "application_security_group" {
  source = "../modules/security_group"

  security_group = {
    name        = "Application SG"
    description = "Application SG"
    vpc_id      = module.vpc.vpc.id
    source_security_group_ingress_rules = [
      {
        from_port                = 3000,
        to_port                  = 3000,
        protocol                 = "tcp",
        source_security_group_id = module.alb_security_group.sg_id
      }
    ]
    cidr_block_egress_rules = [
      {
        from_port   = 0,
        to_port     = 0,
        protocol    = "-1",
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
  tags = local.tags
}

#### Create Security Group for the RDS Database
module "db_security_group" {
  source = "../modules/security_group"

  security_group = {
    name        = "DB SG"
    description = "DB SG"
    vpc_id      = module.vpc.vpc.id
    source_security_group_ingress_rules = [
      {
        from_port                = 5432,
        to_port                  = 5432,
        protocol                 = "tcp",
        source_security_group_id = module.application_security_group.sg_id
      }
    ]
    cidr_block_egress_rules = [
      {
        from_port   = 0,
        to_port     = 0,
        protocol    = "-1",
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
  tags = local.tags
}

### Create Target Group for ECS Tasks
module "alb_tg" {
  source = "../modules/alb/target_group_alb"

  name        = var.tg_name
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc.id
  target_type = var.target_type
  tags        = local.tags
  health_check = {
    enabled             = true
    healthy_threshold   = 3
    interval            = 30
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 3
  }
}

### Create Application Load Balancer
module "alb" {
  source          = "../modules/alb/application_load_balancer"
  name            = "myAppLoadBalancer"
  subnets         = module.public_subnets.subnet_ids
  security_groups = [module.alb_security_group.sg_id]
  tags            = local.tags
}

### Create Application Load Balancer Listeners
module "alb_listener" {
  source = "../modules/alb/listener"

  load_balancer_arn = module.alb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  target_group_arn  = module.alb_tg.target_group.arn
}

### Create ECS Cluster
module "cluster" {
  source = "../modules/ecs/ecs_cluster"

  cluster_name                           = "myEcsCluster"
  container_insights_log_group_retention = 7
  tags                                   = local.tags
}

### Create ECS Task Definition
module "ecs_task" {
  source = "../modules/ecs/ecs_task"

  family = "test-task-def"
  task_role_arn         = module.iam_role.iam_role.arn
  task_exec_role_arn    = module.iam_role.iam_role.arn
  container_definitions = local.container_definition
  name                  = "testapp-task"
  tags                  = local.tags
}

### Create ECS Service for the Application
module "ecs_service" {
  source = "../modules/ecs/ecs_service"

  name                    = "test-app-service"
  cluster_arn                 = module.cluster.cluster.arn
  task_definition_family = "test-task-def"
  task_definition_revision = module.ecs_task.task_definition.revision
  desired_count   = "2"
  target_group_arn = module.alb_tg.target_group.arn
  container_name   = "testapp"
  container_port   = "3000"
  subnets         = module.private_subnets.subnet_ids
  security_groups = [module.application_security_group.sg_id]
  tags                  = local.tags
}


module "iam_role" {
  source = "../modules/iam_role"

  role_name   = "ecs-tf-test-task-execution-role"
  description = "This is Test Terraform IAM Role"
  assume_role_identifiers = [
    "ecs-tasks.amazonaws.com"
  ]
  policy_documents = [
    data.aws_iam_policy_document.policy_document_ecr_access.json,
    data.aws_iam_policy_document.policy_document_secret_manager_access.json,
    data.aws_iam_policy_document.policy_document_cwlogs.json,
  ]
  tags = local.tags
}

module "db_subnet_group" {
  source = "../modules/rds/subnet_group"

  name        = "test-tf-subg"
  description = "This is test subnet group"
  subnet_ids  = module.db_subnets.subnet_ids
  tags        = local.tags
}

module "postgres_db" {
  source = "../modules/rds/rds_instance"

  identifier             = "testrds"
  engine                 = "postgres"
  engine_version         = "13.5"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  username               = "postgres"
  password               = random_password.postgres_db_password.result
  port                   = 5432
  vpc_security_group_ids = [module.db_security_group.sg_id]
  db_subnet_group_name   = module.db_subnet_group.db_subnet_group.id
  tags                   = local.tags
}

module "rds_posrgres_cred" {
  source = "../modules/secret"
  name   = "testrds-db-postgres2"
  secret_string = {
    POSTGRES_PASSWORD = random_password.postgres_db_password.result
  }
  tags = local.tags
}

module "rds_postgres_endpoint" {
  source = "../modules/secret"
  name   = "testrds-db-postgres3"
  secret_string = {
    POSTGRES_HOST     = module.postgres_db.rds.address
  }
  tags = local.tags
}

module "repo" {
  source       = "../modules/ecs/ecr_repo"
  name         = "testapp2"
  scan_on_push = true
  tags         = local.tags
}


resource "docker_registry_image" "app" {

  count = jsondecode(data.external.check_image_exsists.result.success) == true ? 0 : 1
  name  = "${module.repo.repo.repository_url}:${var.image_tag}"

  build {
    context    = "../../"
    dockerfile = "Dockerfile"
  }
}

data "external" "check_image_exsists" {
  program = ["/bin/bash", "${path.module}/script.sh", "testapp2-dev", var.image_tag]
}

module "app_log_group" {
  source = "../modules/cloudwatch_log_group"

  name      = "app-log-group"
  retention = 7
  tags = local.tags
}