output "keypair" {
  value       = aws_key_pair.public_key
  description = "Key Pair ARN"
}

output "key" {
  value       = tls_private_key.ssh_key
  description = "Private key Outputs"
}
