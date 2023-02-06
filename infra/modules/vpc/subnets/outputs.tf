output "subnet_ids" {
  description = "IDs of the subnets"
  value       = aws_subnet.subnets[*].id
}

output "subnet_cidrs" {
  description = "CIDRs blocks of the subnets"
  value       = aws_subnet.subnets[*].cidr_block
}