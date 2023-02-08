# output "vpc_id" {
#   description = "VPC ID"
#   value       = module.vpc.vpc.id
# }

# output "imageid" {
#   description = "VPC ID"
#   value       = data.aws_ecr_image.service_image.id
# }

# output "vpc_ngw_ids" {
#   description = "The AWS ARN(s) for the NAT gateways deployed"
#   value       = module.gateways.ngw_id
# }
# output "vpc_ngw_ips" {
#   description = "The AWS Elastic (Public) IP addresses for the NAT gateways deployed"
#   value       = module.gateways.ngw_ip
# }

# output "vpc_igw_id" {
#   description = "Internet Gateway ID"
#   value       = module.gateways.igw_id
# }

# output "subnets_public_subnet_cidrs" {
#   description = "The Subnet Mask (CIDR block) for the Public Subnet(s) deployed"
#   value       = module.subnets.public_subnet_cidrs
# }

# output "subnets_private_subnet_cidrs" {
#   description = "The Subnet Mask (CIDR block) for the Private Subnet(s) deployed"
#   value       = module.subnets.private_subnet_cidrs
# }

# output "subnets_public_subnet_ids" {
#   description = "The AWS ARN(s) for the Public Subnet(s) deployed"
#   value       = module.subnets.public_subnet_ids
# }

# output "subnets_private_subnet_ids" {
#   description = "The AWS ARN(s) for the Private Subnet(s) deployed"
#   value       = module.subnets.private_subnet_ids
# }

output "image_digest_exsists" {
  description = ""
  value       = jsondecode(data.external.check_image_exsists.result.success)
}

output "ec2_instance_id" {
  description = ""
  value       = module.bastion_instance.ec2_instance.arn
}
