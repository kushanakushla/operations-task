variable "tags" {
  type        = map(string)
  description = "resource tag mapping"
}

variable "retention" {
  description = "Specifies the number of days to retain logs."
  type        = number
  default     = 1
  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, 0], var.retention)
    error_message = "Valid values are 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, or 0."
  }
}
variable "name" {
  description = "The name of the log group"
  type        = string
  default     = null
}
variable "kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data."
  type        = string
  default     = null
}
