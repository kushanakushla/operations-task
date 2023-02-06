output "log_group_arn" {
  value       = aws_cloudwatch_log_group.log_group.arn
  description = "Log group ARN"
}

output "log_group_name" {
  value       = aws_cloudwatch_log_group.log_group.name
  description = "Log group name"
}