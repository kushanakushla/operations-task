resource "aws_lb_target_group" "alb_tg" {
  name        = format("%s-%s-tg", var.name, var.tags["Environment"])
  target_type = var.target_type
  port        = var.port
  protocol    = var.protocol
  vpc_id      = var.vpc_id
  tags        = var.tags

  health_check {
    enabled             = var.health_check["enabled"]
    healthy_threshold   = var.health_check["healthy_threshold"]
    interval            = var.health_check["interval"]
    matcher             = var.health_check["matcher"] != null ? var.health_check["matcher"] : null
    path                = var.health_check["path"] != null ? var.health_check["path"] : null
    protocol            = var.health_check["protocol"]
    timeout             = var.health_check["timeout"]
    unhealthy_threshold = var.health_check["unhealthy_threshold"]
  }
}