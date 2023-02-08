variable "num_az" {
  type        = number
  description = "Number of Availability Zones"
}

variable "tags" {
  type        = map(string)
  description = "resource tag mapping"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}
variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "public_subnet_ids" {
  description = "IDs of the public subnets "
  type        = list(string)
}

variable "vpc_azs" {
  description = "List of VPC Availability Zones"
  type        = list(string)
}