resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags   = merge({ Name = "igw-${var.vpc_name}" }, var.tags)
}

resource "aws_eip" "ngw_eip" {
  count = var.num_az
  tags  = merge({ Name = "ngeip-${var.vpc_name}-${var.vpc_azs[count.index]}" }, var.tags)

}

resource "aws_nat_gateway" "ngw" {
  count         = var.num_az
  allocation_id = aws_eip.ngw_eip[count.index].id
  subnet_id     = var.public_subnet_ids[count.index]
  depends_on    = [aws_internet_gateway.igw]
  tags          = merge({ Name = "ngw-${var.vpc_name}-${var.vpc_azs[count.index]}" }, var.tags)
}