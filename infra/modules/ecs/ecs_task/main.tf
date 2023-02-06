resource "aws_ecs_task_definition" "definition" {
  container_definitions = var.container_definitions
  family                = var.family
  task_role_arn         = var.task_role_arn
  execution_role_arn    = var.task_exec_role_arn
  network_mode          = "awsvpc"
  cpu = "256"
  memory = "512"
  requires_compatibilities = ["FARGATE"]
  tags                  = var.tags
  }