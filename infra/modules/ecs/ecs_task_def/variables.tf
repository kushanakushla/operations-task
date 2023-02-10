variable "tags" {
  type        = map(string)
  description = "resource tag mapping"
}

variable "container_definitions" {
  type        = string
  description = "The JSON encoded array of container definitions for the task"
}

variable "family" {
  type        = string
  description = "The name of a family that this task definition is registered to. Up to 255 letters (uppercase and lowercase), numbers, hyphens, and underscores are allowed."
}

variable "task_role_arn" {
  type        = string
  description = "The ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services"
  default     = null
}

variable "task_exec_role_arn" {
  type        = string
  description = "The ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services"
  default     = null
}

variable "cpu" {
  type        = number
  description = "CPU ammount for the task"
  default     = "256"
}

variable "memory" {
  type        = number
  description = "memory ammount for the task"
  default     = "512"
}
