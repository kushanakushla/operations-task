output "igw_id" {
  description = "Internet Gateway (IGW) ID"
  value       = aws_internet_gateway.igw.id
}

output "ngw_id" {
  description = "Network Address Translation Gateway (NGW) ID(s)"
  value       = aws_nat_gateway.ngw[*].id
}

output "ngw_ip" {
  description = "Network Address Translation Gateway (NGW) IP address(es)"
  value       = aws_nat_gateway.ngw[*].public_ip
}