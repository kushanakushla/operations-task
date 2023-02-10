variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR network address"
}

variable "application" {
  type        = string
  description = "Name of the Application"
}

variable "tags" {
  type = map(string)
}

variable "global_tags" {
  type = map(string)
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "pub_sub_map_public_ip_on_launch" {
  default     = false
  type        = bool
  description = "Enable public Ip for subnets"
}

variable "priv_subnet_type" {
  type        = string
  default     = "private"
  description = "name map for private subnets"
}
variable "pub_subnet_type" {
  type        = string
  default     = "public"
  description = "name map for public subnets"
}
variable "db_subnet_type" {
  type        = string
  default     = "db"
  description = "name map for db subnets"
}
variable "priv_subnets_cidr" {
  description = "CIDR for Private subnet"
  type        = list(string)
}

variable "pub_subnets_cidr" {
  description = "CIDR for Public subnet"
  type        = list(string)
}

variable "db_subnets_cidr" {
  description = "CIDR for DB subnets"
  type        = list(string)
}

variable "vpc_azs" {
  description = ""
  type        = list(string)
}

variable "num_az" {}

variable "db_username" {
  type        = string
  default     = "postgres"
  description = "username of the rds database"
}

variable "db_name" {
  type        = string
  default     = "postgres"
  description = "name of the database to created within rds instance"
}

variable "db_instance_class" {
  type        = string
  default     = "postgres"
  description = "class of the rds db instance"
}

variable "db_allocated_storage" {
  type        = number
  default     = 20
  description = "allocated storage size for DB in gigabytes"
}


variable "vpc_flow_iam_set" {
  default = true
  type    = bool
}

variable "image_tag" {
  type        = string
  description = "tag of the image"
}

variable "ecs_task_cpu" {
  type        = number
  description = "CPU ammount for the task"
  default     = "256"
}

variable "ecs_task_memory" {
  type        = number
  description = "memory ammount for the task"
  default     = "512"
}

variable "desired_task_count" {
  type        = number
  description = "Desired ECS task count for the service"
  default     = "2"
}

variable "container_name" {
  type        = string
  description = "name of the application container"
  default     = "app-container"
}

variable "container_port" {
  type        = number
  description = "application container port"
  default     = 80
}

variable "task_execution_role_name" {
  type        = string
  description = "name of the ecs task execution role"
  default     = "ecs-task-exec-role"
}

variable "db_restore_role_name" {
  type        = string
  description = "name of the db restore iam role"
  default     = "db-restore-ec2-role"
}

variable "application_image_name" {
  type        = string
  description = "name of the application ecr image"
  default     = "db-restore-ec2-role"
}
