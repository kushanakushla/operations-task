variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "vpc_name" {
  type        = string
  description = "Name for the VPC"
}

variable "tags" {
  type = map(string)
  description = "resource tag mapping"
}