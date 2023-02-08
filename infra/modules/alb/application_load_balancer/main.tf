resource "aws_lb" "alb" {
  name               = format("%s-%s-alb", var.name, var.tags["Environment"])
  internal           = var.internal_lb
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets
  enable_http2       = true
  idle_timeout       = var.idle_timeout

  enable_deletion_protection = var.enable_deletion_protection
  drop_invalid_header_fields = true
  tags                       = var.tags
}
