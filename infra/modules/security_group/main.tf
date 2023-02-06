resource "aws_security_group" "sg" {
  name        = var.security_group["name"]
  description = var.security_group["description"]
  vpc_id      = var.security_group["vpc_id"]
  tags        = var.tags
}

resource "aws_security_group_rule" "cidr_block_ingress" {
  count             = var.security_group["cidr_block_ingress_rules"] == null ? 0 : length(var.security_group["cidr_block_ingress_rules"])
  type              = "ingress"
  from_port         = var.security_group["cidr_block_ingress_rules"][count.index]["from_port"]
  to_port           = var.security_group["cidr_block_ingress_rules"][count.index]["to_port"]
  protocol          = var.security_group["cidr_block_ingress_rules"][count.index]["protocol"]
  cidr_blocks       = var.security_group["cidr_block_ingress_rules"][count.index]["cidr_blocks"]
  description       = lookup(var.security_group["cidr_block_ingress_rules"][count.index], "description", null)
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "source_security_group_ingress" {
  count                    = var.security_group["source_security_group_ingress_rules"] == null ? 0 : length(var.security_group["source_security_group_ingress_rules"])
  type                     = "ingress"
  from_port                = var.security_group["source_security_group_ingress_rules"][count.index]["from_port"]
  to_port                  = var.security_group["source_security_group_ingress_rules"][count.index]["to_port"]
  protocol                 = var.security_group["source_security_group_ingress_rules"][count.index]["protocol"]
  source_security_group_id = var.security_group["source_security_group_ingress_rules"][count.index]["source_security_group_id"]
  description              = lookup(var.security_group["source_security_group_ingress_rules"][count.index], "description", null)
  security_group_id        = aws_security_group.sg.id
}

resource "aws_security_group_rule" "cidr_block_egress" {
  count             = var.security_group["cidr_block_egress_rules"] == null ? 0 : length(var.security_group["cidr_block_egress_rules"])
  type              = "egress"
  from_port         = var.security_group["cidr_block_egress_rules"][count.index]["from_port"]
  to_port           = var.security_group["cidr_block_egress_rules"][count.index]["to_port"]
  protocol          = var.security_group["cidr_block_egress_rules"][count.index]["protocol"]
  cidr_blocks       = var.security_group["cidr_block_egress_rules"][count.index]["cidr_blocks"]
  description       = lookup(var.security_group["cidr_block_egress_rules"][count.index], "description", null)
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "source_security_group_egress" {
  count                    = var.security_group["source_security_group_egress_rules"] == null ? 0 : length(var.security_group["source_security_group_egress_rules"])
  type                     = "egress"
  from_port                = var.security_group["source_security_group_egress_rules"][count.index]["from_port"]
  to_port                  = var.security_group["source_security_group_egress_rules"][count.index]["to_port"]
  protocol                 = var.security_group["source_security_group_egress_rules"][count.index]["protocol"]
  source_security_group_id = var.security_group["source_security_group_egress_rules"][count.index]["source_security_group_id"]
  description              = lookup(var.security_group["source_security_group_egress_rules"][count.index], "description", null)
  security_group_id        = aws_security_group.sg.id
}
