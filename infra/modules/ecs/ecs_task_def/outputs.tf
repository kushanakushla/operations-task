output "task_definition" {
  value       = aws_ecs_task_definition.definition
  description = "ECS Task Definition resource"
  sensitive   = true
}
