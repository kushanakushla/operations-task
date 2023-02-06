resource "aws_db_subnet_group" "subnet_group" {
  name        = format("%s-%s-tg", var.name, var.tags["Environment"])
  description = var.description
  subnet_ids  = var.subnet_ids
  tags = var.tags
}
