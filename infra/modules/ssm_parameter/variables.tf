variable "name" {
  default     = ""
  type        = string
  description = "Map of key pair values for secret"
}

variable "tags" {
  type        = map(string)
  description = "resource tag mapping"
}

variable "type" {
  type        = string
  description = "type of the ssm parameter"
}

variable "value" {
  type        = string
  description = "SSM parameter value"
}
