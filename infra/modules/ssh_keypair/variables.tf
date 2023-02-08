variable "key_name" {
  type        = string
  description = "name of the keypair"
}

variable "tags" {
  type        = map(string)
  description = "Tags for parameter and keypair"
  default = {
  }
}
