resource "random_password" "rds-db-password" {
  length  = 32
  upper   = true
  lower   = true
  numeric = true
  special = false
}

resource "aws_db_instance" "rds_instance" {
  identifier        = format("%s-%s-rds", var.identifier, var.tags["Environment"])

  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  storage_encrypted = var.storage_encrypted
  kms_key_id        = var.kms_key_id

  db_name                             = var.db_name
  username                            = var.username
  password                            = var.password
  port                                = var.port

  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name
  parameter_group_name   = var.parameter_group_name
  option_group_name      = var.option_group_name
  network_type           = var.network_type
  skip_final_snapshot = true

  multi_az            = var.multi_az

  tags = var.tags
}