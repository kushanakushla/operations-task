output "secret" {
  value       = aws_secretsmanager_secret.secret
  description = "Secret Outputs"
}