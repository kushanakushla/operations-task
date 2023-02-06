variable "vpc_id" {}

variable "vpc_flow_iam_set" {
  default = true
  type    = bool
  description = "set true/false to enable disable creation of iam roles and policies for vpc flow logs"
}

variable "tags" {
  type = map(string)
  description = "resource tag mapping"
}

variable "vpc_name" {
  type        = string
  description = "name of the vpc"
}
