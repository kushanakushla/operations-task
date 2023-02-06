variable "num_az" {
  type = number
  description = "Number of Availability zones"
}

variable "tags" {
  type = map(string)
  description = "resource tag mapping"
}

variable "igw_id" {
  type        = string
  description = "ID of the Internet gatway"
}

variable "ngw_id" {
  description = "List of NAT gateway IDs"
  type        = list(string)
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs "
  type        = list(string)
}

variable "db_subnet_ids" {
  description = "List of DB subnet IDs"
  type        = list(string)
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}

variable "vpc_azs" {
  description = "Availability zone of the VPC"
  type        = list(string)
}