variable "tags" {
  type        = map(string)
  description = "resource tag mapping"
}

variable "cluster_name" {
  type        = string
  description = "Name for the ECS Cluster."
  default     = null
}
variable "container_insights_log_group_retention" {
  description = "Specifies the number of days you want to retain log events in the specified log group."
  type        = number
  default     = 1
}