resource "aws_secretsmanager_secret" "secret" {
  name = format("%s-%s-credentials", var.name, var.tags["Environment"])
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "secret" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = var.secret_string
}