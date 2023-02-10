resource "aws_ecs_service" "service" {
  name            = format("%s-%s-service", var.name, var.tags["Environment"])
  cluster         = var.cluster_arn
  task_definition = format("%s:%s", var.task_definition_family, var.task_definition_revision)
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  propagate_tags  = "SERVICE"
  tags            = var.tags

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }


  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = var.assign_public_ip
  }
}
