resource "aws_ecs_task_definition" "definition" {
  container_definitions    = var.container_definitions
  family                   = format("%s-%s-task-definition", "${var.family}", "${var.tags["Environment"]}")
  task_role_arn            = var.task_role_arn
  execution_role_arn       = var.task_exec_role_arn
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  requires_compatibilities = ["FARGATE"]
  tags                     = var.tags
}
