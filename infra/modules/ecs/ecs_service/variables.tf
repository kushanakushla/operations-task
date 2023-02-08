variable "tags" {
  type        = map(string)
  description = "The metadata that you apply to the service to help you categorize and organize them. Each tag consists of a key and an optional value, both of which you define."
}

variable "cluster_arn" {
  type        = string
  description = "The short name or full Amazon Resource Name (ARN) of the cluster on which to run your service."
}

variable "name" {
  type        = string
  description = "The name of your service. Up to 255 letters (uppercase and lowercase), numbers, and hyphens are allowed. Service names must be unique within a cluster, but you can have similarly named services in multiple clusters within a Region or across multiple Regions."
}

variable "task_definition_family" {
  type        = string
  description = "The name of your service. Up to 255 letters (uppercase and lowercase), numbers, and hyphens are allowed. Service names must be unique within a cluster, but you can have similarly named services in multiple clusters within a Region or across multiple Regions."
}

variable "task_definition_revision" {
  type        = number
  description = "The name of your service. Up to 255 letters (uppercase and lowercase), numbers, and hyphens are allowed. Service names must be unique within a cluster, but you can have similarly named services in multiple clusters within a Region or across multiple Regions."
}

variable "desired_count" {
  type        = number
  description = "The name of your service. Up to 255 letters (uppercase and lowercase), numbers, and hyphens are allowed. Service names must be unique within a cluster, but you can have similarly named services in multiple clusters within a Region or across multiple Regions."
}

variable "subnets" {
  description = "The network configuration for the service. This parameter is required for task definitions that use the `awsvpc` network mode to receive their own elastic network interface, and it is not supported for other network modes."
  type        = list(string)
}

variable "security_groups" {
  description = "The network configuration for the service. This parameter is required for task definitions that use the `awsvpc` network mode to receive their own elastic network interface, and it is not supported for other network modes."
  type        = list(string)
}

variable "target_group_arn" {
  type        = string
  description = "The short name or full Amazon Resource Name (ARN) of the cluster on which to run your service."
}

variable "container_port" {
  type        = number
  description = "The name of your service. Up to 255 letters (uppercase and lowercase), numbers, and hyphens are allowed. Service names must be unique within a cluster, but you can have similarly named services in multiple clusters within a Region or across multiple Regions."
}

variable "assign_public_ip" {
  type        = bool
  default     = false
  description = "The name of your service. Up to 255 letters (uppercase and lowercase), numbers, and hyphens are allowed. Service names must be unique within a cluster, but you can have similarly named services in multiple clusters within a Region or across multiple Regions."
}

variable "container_name" {
  type        = string
  description = "The name of your service. Up to 255 letters (uppercase and lowercase), numbers, and hyphens are allowed. Service names must be unique within a cluster, but you can have similarly named services in multiple clusters within a Region or across multiple Regions."
}