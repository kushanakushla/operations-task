variable "tags" {
  type        = map(string)
  description = "resource tag mapping"
}

variable "name" {
  type        = string
  description = "Name of the ECR repository"
}

variable "scan_on_push" {
  default     = true
  type        = bool
  description = "Whether pushed image should be scanned for security vulnerabilities"
}

variable "image_tag_mutability" {
  type        = string
  description = "The tag mutability setting for the repository. Must be one of: `MUTABLE` or `IMMUTABLE`."
  default     = "IMMUTABLE"
}