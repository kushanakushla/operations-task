variable "load_balancer_arn" {
  type        = string
  description = "ARN of the load balancer"
}
variable "port" {
  type        = number
  description = "Port on which targets receive traffic"
}
variable "protocol" {
  type        = string
  description = "Protocol to use for routing traffic to the targets."
}

variable "ssl_policy" {
  type        = string
  description = "SSL policy to be used with the listener"
  default     = ""
}
variable "certificate_arn" {
  type        = string
  description = "ACM SSL Certificate ARN"
  default     = ""
}

variable "target_group_arn" {
  type        = string
  description = "ARN of the target_group"
}