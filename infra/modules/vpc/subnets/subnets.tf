resource "aws_subnet" "subnets" {
  count             = length(var.vpc_azs)
  vpc_id            = var.vpc_id
  availability_zone = element(var.vpc_azs, count.index)
  cidr_block        = element(var.subnets_cidr, count.index)
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags              = merge({ Name = "${var.subnet_type}-${var.vpc_name}-${var.vpc_azs[count.index]}" }, var.tags)
}