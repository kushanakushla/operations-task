variable "tags" {
  type = map(string)
  description = "resource tag mapping"
}
variable "name" {
  type        = string
  description = "The name of the load balancer."
}
variable "port" {
  type        = number
  description = "Port on which targets receive traffic."
}
variable "protocol" {
  type        = string
  description = "Protocol to use for routing traffic to the targets."
}
variable "vpc_id" {
  type        = string
  description = "ID of the VPC."
}
variable "health_check" {
  type = object({
    enabled             = optional(bool)
    healthy_threshold   = optional(number)
    interval            = optional(number)
    matcher             = optional(string)
    path                = optional(string)
    port                = optional(string)
    protocol            = optional(string)
    timeout             = optional(number)
    unhealthy_threshold = optional(number)
  })
  default = {
    enabled             = true
    healthy_threshold   = 3
    interval            = 30
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 3
  }
  description = "Health Check configuration block."
}
variable "target_type" {
  default     = "instance"
  type        = string
  description = "Type of target that you must specify when registering targets with this target group."
  validation {
    condition     = contains(["instance", "ip", "lambda"], var.target_type)
    error_message = "Supported target types are (\"instance\", \"ip\", \"lambda\")."
  }
}