variable "tags" {
  type        = map(string)
  description = "resource tag mapping"
}

variable "assume_role_identifiers" {
  type        = list(string)
  description = "The trust policy that is associated with this role. Trust policies define which entities can assume the role. You can associate only one trust policy with a role."
  default     = []
}

variable "assume_role_accounts" {
  type        = list(string)
  description = "List of Account ARNs to trust."
  default     = []
}

variable "role_name" {
  type        = string
  description = "Name of the IAM Role"
}

variable "managed_policies" {
  type        = list(string)
  description = "A list of Amazon Resource Names (ARNs) of the IAM managed policies to attached with the role"
  default     = []
}

variable "policy_documents" {
  type        = list(string)
  description = "Adds or updates an inline policy document that is embedded in the specified IAM role."
  default     = []
}

variable "role_path" {
  default     = "/"
  type        = string
  description = "The path to the role."
}

variable "description" {
  default     = ""
  type        = string
  description = "A description of the role that you provide."
}