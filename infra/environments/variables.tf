variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR network address"
}

variable "vpc_name" {
  type        = string
  description = "VPC name"
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
  description = "Type of the Subnet"
}
variable "pub_subnet_type" {
  type        = string
  description = "Type of the Subnet"
}
variable "db_subnet_type" {
  type        = string
  description = "Type of the Subnet"
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

variable "tg_name" {
  type        = string
  description = "The name of the load balancer. This name must be unique per region per account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, must not begin or end with a hyphen, and must not begin with \"internal-\"."
}

variable "target_type" {
  default     = "instance"
  type        = string
  description = "Type of target that you must specify when registering targets with this target group."
  validation {
    condition     = contains(["instance", "ip", "lambda"], var.target_type)
    error_message = "Supported target types are (\"instance\", \"ip\", \"lambda\")."
  }
}

variable "cluster_name" {
  type        = string
  description = "A user-generated string that you use to identify your cluster. If you don't specify a name, AWS CloudFormation generates a unique physical ID for the name."
  default     = null
}
# variable "pub_ingress" {
#   type = list(object({ description = string, from_port = number, to_port = number, protocol = string, cidr_blocks = list(string), self = bool }))
# }

# variable "pub_egress" {
#   type = list(object({ description = string, from_port = number, to_port = number, protocol = string, cidr_blocks = list(string) }))
# }

# variable "priv_ingress" {
#   type = list(object({ description = string, from_port = number, to_port = number, protocol = string, cidr_blocks = list(string), self = bool }))
# }

# variable "priv_egress" {
#   type = list(object({ description = string, from_port = number, to_port = number, protocol = string, cidr_blocks = list(string) }))
# }

# variable "pub_security_group_name" {
#   description = "Public Security Group Name"
#   type        = string
# }

# variable "priv_security_group_name" {
#   description = "Public Security Group Name"
#   type        = string
# }

variable "vpc_flow_iam_set" {
  default = true
  type    = bool
}

variable "image_tag" {
  type        = string
  description = "tag of the image"
}