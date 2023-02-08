variable "tags" {
  type        = map(string)
  description = "resource tag mapping"
}

variable "name" {
  type        = string
  description = "Name of the security group"
}

variable "security_group" {
  type = object({
    description = string,
    vpc_id      = string,
    cidr_block_ingress_rules = optional(list(object({
      from_port   = number,
      to_port     = number,
      protocol    = string,
      cidr_blocks = list(string),
      description = optional(string)
    }))),
    source_security_group_ingress_rules = optional(list(object({
      from_port                = number,
      to_port                  = number,
      protocol                 = string,
      source_security_group_id = string,
      description              = optional(string)
    }))),
    cidr_block_egress_rules = optional(list(object({
      from_port   = number,
      to_port     = number,
      protocol    = string,
      cidr_blocks = list(string),
      description = optional(string)
    }))),
    source_security_group_egress_rules = optional(list(object({
      from_port                = number,
      to_port                  = number,
      protocol                 = string,
      source_security_group_id = string,
      description              = optional(string)
    }))),
  })
  description = "Inbound and outbound rule configuration for security group"
}
