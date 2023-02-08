resource "aws_ecs_cluster" "cluster" {
  name = format("%s-%s-ecs-cluster", var.cluster_name, var.tags["Environment"])

  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = var.tags
}

module "log_group" {
  source = "../../cloudwatch_log_group"

  name      = "/aws/ecs/containerinsights/${aws_ecs_cluster.cluster.name}/performance"
  retention = var.container_insights_log_group_retention
  tags      = var.tags
}
