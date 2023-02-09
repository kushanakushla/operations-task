### Create VPC
module "vpc" {
  source = "../modules/vpc/vpc"

  vpc_cidr = var.vpc_cidr
  vpc_name = var.application
  tags     = local.tags
}

### Create Public Subnets
module "public_subnets" {
  source = "../modules/vpc/subnets"

  region                  = var.region
  vpc_azs                 = var.vpc_azs
  vpc_id                  = module.vpc.vpc.id
  vpc_name                = var.application
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
  vpc_name     = var.application
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
  vpc_name     = var.application
  subnets_cidr = var.db_subnets_cidr
  subnet_type  = var.db_subnet_type
  tags         = local.tags
}

### Create NAT & Internet Gateways
module "gateways" {
  source = "../modules/vpc/gateways"

  vpc_name          = var.application
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
  vpc_name           = var.application
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
  vpc_name         = var.application
  tags             = local.tags
}

### Create Security Group for the Application Load Balancer
module "alb_security_group" {
  source = "../modules/security_group"
  name   = "${var.application}-alb-sg"

  security_group = {
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

  name = "${var.application}-application-sg"
  security_group = {

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

  name = "${var.application}-db-sg"
  security_group = {
    description = "RDS DB SG"
    vpc_id      = module.vpc.vpc.id
    source_security_group_ingress_rules = [
      {
        from_port                = 5432,
        to_port                  = 5432,
        protocol                 = "tcp",
        source_security_group_id = module.application_security_group.sg_id
      }
    ]
    cidr_block_ingress_rules = [
      {
        from_port   = 5432,
        to_port     = 5432,
        protocol    = "tcp",
        cidr_blocks = ["${var.db_subnets_cidr[0]}"]
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

  name        = var.application
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc.id
  target_type = "ip"
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
  name            = var.application
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

### Generate a random password for RDS DB Instance
resource "random_password" "postgres_db_password" {
  length  = 16
  upper   = true
  lower   = true
  numeric = true
  special = false
}

### Create RDS DB subnet group
module "db_subnet_group" {
  source = "../modules/rds/subnet_group"

  name        = var.application
  description = "RDS Postgres DB subnet group for rates appplication"
  subnet_ids  = module.db_subnets.subnet_ids
  tags        = local.tags
}

### Create RDS postgres DB Instance
module "postgres_db" {
  source = "../modules/rds/rds_instance"

  identifier             = var.application
  engine                 = "postgres"
  engine_version         = "13.5"
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  username               = var.db_username
  db_name                = var.db_name
  password               = random_password.postgres_db_password.result
  port                   = 5432
  vpc_security_group_ids = [module.db_security_group.sg_id]
  db_subnet_group_name   = module.db_subnet_group.db_subnet_group.id
  tags                   = local.tags
}

### Create RDS db password secret
module "rds_postgres_cred" {
  source        = "../modules/secret"
  name          = "${var.application}-rds-db-cred2"
  secret_string = random_password.postgres_db_password.result
  tags          = local.tags
}

### Create RDS db address secret
module "rds_postgres_endpoint" {
  source        = "../modules/secret"
  name          = "${var.application}-rds-db-address2"
  secret_string = module.postgres_db.rds.address
  tags          = local.tags
}

### Create ECS Cluster
module "cluster" {
  source = "../modules/ecs/ecs_cluster"

  cluster_name                           = var.application
  container_insights_log_group_retention = 7
  tags                                   = local.tags
}

### Create ECS Task Definition
module "ecs_task_def" {
  source                = "../modules/ecs/ecs_task_def"
  cpu                   = var.ecs_task_cpu
  memory                = var.ecs_task_memory
  family                = var.application
  task_role_arn         = module.ecs_task_execution_role.iam_role.arn
  task_exec_role_arn    = module.ecs_task_execution_role.iam_role.arn
  container_definitions = local.container_definition
  tags                  = local.tags
}

### Create ECS Service for the Application
module "ecs_service" {
  depends_on = [
    module.postgres_db
  ]
  source = "../modules/ecs/ecs_service"

  name                     = var.application
  cluster_arn              = module.cluster.cluster.arn
  task_definition_family   = module.ecs_task_def.task_definition.family
  task_definition_revision = module.ecs_task_def.task_definition.revision
  desired_count            = var.desired_task_count
  target_group_arn         = module.alb_tg.target_group.arn
  container_name           = var.container_name
  container_port           = var.container_port
  subnets                  = module.private_subnets.subnet_ids
  security_groups          = [module.application_security_group.sg_id]
  tags                     = local.tags
}

### Create ECS task execution IAM Role
module "ecs_task_execution_role" {
  source = "../modules/iam_role"

  role_name   = var.task_execution_role_name
  description = "This is ecs task exec role for the application"
  assume_role_identifiers = [
    "ecs-tasks.amazonaws.com"
  ]
  policy_documents = [
    data.aws_iam_policy_document.policy_document_ecr_access.json,
    data.aws_iam_policy_document.policy_document_secret_manager_access.json,
    data.aws_iam_policy_document.policy_document_cwlogs.json,
    data.aws_iam_policy_document.policy_document_ecr_auth.json
  ]
  tags = local.tags
}

### Create Bastion IAM Role
module "db_restore_ec2_instance_role" {
  source = "../modules/iam_role"

  role_name   = var.db_restore_role_name
  description = "This is IAM role used with db restore ec2"
  assume_role_identifiers = [
    "ec2.amazonaws.com"
  ]
  managed_policies = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  tags             = local.tags
}

### Create ECR Repo
module "repo" {
  source       = "../modules/ecs/ecr_repo"
  name         = var.application_image_name
  scan_on_push = true
  tags         = local.tags
}

### Build and Push application docker image
resource "docker_registry_image" "app" {
  count         = jsondecode(data.external.check_image_exsists.result.success) == true ? 0 : 1
  name          = docker_image.app[count.index].name
  keep_remotely = true
}

resource "docker_image" "app" {
  count = jsondecode(data.external.check_image_exsists.result.success) == true ? 0 : 1
  name  = "${module.repo.repo.repository_url}:${var.image_tag}"
  build {
    context = "../../"
  }
}

### Create application cloudwatch log group
module "app_log_group" {
  source = "../modules/cloudwatch_log_group"

  name      = "sssssss" #module.ecs_service.service.name
  retention = 7
  tags      = local.tags
}

module "db_restore_instance" {

  depends_on = [
    module.postgres_db
  ]
  source        = "../modules/ec2"
  ami           = data.aws_ami.amazon-2.image_id
  instance_type = "t2.micro"
  tags          = local.tags
  # key_name      = module.bastion_ssh_keypair.keypair.key_name

  volume_type = "gp2"
  volume_size = "20"

  vpc_security_group_ids = [module.db_security_group.sg_id]
  subnet_id              = module.db_subnets.subnet_ids[0]
  iam_instance_profile   = aws_iam_instance_profile.db_restore_ec2_instance.name
  user_data              = <<EOF
  #!/bin/bash
  yum update -y
  amazon-linux-extras enable postgresql14
  yum install postgresql -y
  wget https://raw.githubusercontent.com/kushanakushla/operations-task/master/db/rates.sql
  export PGPASSWORD=${random_password.postgres_db_password.result}
  psql -U ${var.db_username} -h ${module.postgres_db.rds.address} -d ${var.db_name} -f rates.sql
  EOF

}

resource "aws_iam_instance_profile" "db_restore_ec2_instance" {
  name = var.db_restore_role_name
  role = module.db_restore_ec2_instance_role.iam_role.name
}
