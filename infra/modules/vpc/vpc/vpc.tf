
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge({ Name = format("%s-app-vpc-%s", "${var.vpc_name}", "${var.tags["Environment"]}") }, var.tags)
}

