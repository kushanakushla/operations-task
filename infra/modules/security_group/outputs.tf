output "security_group" {
  value       = aws_security_group.sg
  description = "(DEPRECATED) Security Group resource"
}

output "sg_id" {
  value       = aws_security_group.sg.id
  description = "Security Group ID"
}