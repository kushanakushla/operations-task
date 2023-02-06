resource "aws_cloudwatch_log_group" "log_group" {
  name              = var.name
  retention_in_days = var.retention
  tags              = var.tags
  kms_key_id        = var.kms_key_id
}
