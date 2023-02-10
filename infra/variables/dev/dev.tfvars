### Global Variables
global_tags = {
  "App"         = "testapp"
  "ManagedBy"   = "Terraform"
  "Environment" = "dev"
}

tags = {
}

### VPC Components related variables

region                          = "us-east-1"
vpc_cidr                        = "10.240.26.0/23"
priv_subnets_cidr               = ["10.240.26.128/26", "10.240.26.192/26"]
pub_subnets_cidr                = ["10.240.26.0/26", "10.240.26.64/26"]
db_subnets_cidr                 = ["10.240.27.0/26", "10.240.27.64/26"]
vpc_azs                         = ["us-east-1a", "us-east-1b"]
num_az                          = 2
pub_sub_map_public_ip_on_launch = "true"

## If creating multiple VPCs on same account set this to false in other vpc creation configs 
vpc_flow_iam_set = true

application = "xeneta"

db_username          = "postgres"
db_name              = "rates"
db_instance_class    = "db.t3.micro"
db_allocated_storage = "20"

ecs_task_cpu       = "256"
ecs_task_memory    = "512"
desired_task_count = "2"
container_name     = "rates-app-container"
container_port     = "3000"

task_execution_role_name = "xeneta-task-exec-role-dev"
db_restore_role_name     = "db-restore-ec2-role-dev"
application_image_name   = "rates-app-dev"
