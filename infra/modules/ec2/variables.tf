variable "ami" {
  type        = string
  default     = "ami-0ff8a91507f77f867"
  description = "AMI ID to launch the instance"
}

variable "instance_type" {
  type        = string
  default     = "t3a.medium"
  description = "Ec2 instance type"
}

variable "key_name" {
  type        = string
  description = "ssh key name"
  default     = ""
}

variable "volume_type" {
  type        = string
  default     = "standard"
  description = "EBS root volume type"
}

variable "volume_size" {
  type        = string
  default     = "20"
  description = "Size of the EBS root volume"
}

variable "root_volume_delete_on_termination" {
  type        = bool
  description = "Delete root EBS volume on termination"
  default     = true
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Assocaite public IP with the Instance"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "resource tag mapping"
}


variable "subnet_id" {
  type        = string
  description = "subnet id of the instance"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "security group ids to associate with the instance"
}

variable "user_data" {
  type        = string
  description = "userdata for ec2 instance"
  default     = ""
}

variable "iam_instance_profile" {
  default     = ""
  type        = string
  description = "IAM Instance profile for the instance"
}
