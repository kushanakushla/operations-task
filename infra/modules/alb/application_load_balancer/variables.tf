variable "tags" {
  type        = map(string)
  description = "resource tag mapping"
}

variable "name" {
  type        = string
  description = "The name of the load balancer."
}
variable "internal_lb" {
  default     = false
  type        = bool
  description = "If true, the LB will be internal."
}
variable "security_groups" {
  default     = []
  type        = list(string)
  description = "A list of security group IDs to assign to the LB."
}
variable "subnets" {
  default     = []
  type        = list(string)
  description = "A list of subnet IDs to attach to the LB."
}
variable "idle_timeout" {
  default     = 60
  type        = number
  description = "Idle timeout value"
  validation {
    condition     = var.idle_timeout >= 1 && var.idle_timeout <= 4000
    error_message = "Idle Timeout must be 1-4000 seconds."
  }
}
variable "enable_deletion_protection" {
  default     = false
  type        = bool
  description = "If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false."
}