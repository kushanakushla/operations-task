variable "secret_string" {
  default     = ""
  type        = string
  description = "Map of key pair values for secret"
}

variable "tags" {
  type        = map(string)
  description = "resource tag mapping"
}

variable "name" {
  type        = string
  description = "Name of the secret"
}