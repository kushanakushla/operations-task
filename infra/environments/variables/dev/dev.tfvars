#Tags
global_tags = {
  "App"         = "testapp"
  "ManagedBy"   = "Terraform"
  "Environment" = "dev"
}

# Define CIDR block for VPC
vpc_name = "test"

region                          = "us-east-1"
vpc_cidr                        = "10.240.26.0/23"
priv_subnets_cidr               = ["10.240.26.128/26", "10.240.26.192/26"]
pub_subnets_cidr                = ["10.240.26.0/26", "10.240.26.64/26"]
db_subnets_cidr                 = ["10.240.27.0/26", "10.240.27.64/26"]
vpc_azs                         = ["us-east-1a", "us-east-1b"]
num_az                          = 2
priv_subnet_type                = "private"
pub_subnet_type                 = "public"
db_subnet_type                  = "db"
pub_sub_map_public_ip_on_launch = "true"
vpc_flow_iam_set                = true

tags = {
}

tg_name      = "application-tg"
target_type  = "ip"
cluster_name = "ecs-app-test"
image_tag    = "9.0.0"