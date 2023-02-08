variable "region" {
  description = "AWS Region"
  type        = string
}

variable "subnets_cidr" {
  description = "List of CIDR blocks for the subnets"
  type        = list(string)
}

variable "vpc_azs" {
  description = "List of Availability Zones"
  type        = list(string)
}

variable "tags" {
  type        = map(string)
  description = "resource tag mapping"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}

variable "subnet_type" {
  type        = string
  description = "Type of the Subnet"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "map_public_ip_on_launch" {
  default     = false
  type        = bool
  description = "Enable public Ip for subnets"
}