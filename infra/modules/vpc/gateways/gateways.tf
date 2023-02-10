resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags   = merge({ Name = format("igw-%s-%s", "${var.vpc_name}", "${var.tags["Environment"]}") }, var.tags)
}

resource "aws_eip" "ngw_eip" {
  count = var.num_az
  tags  = merge({ Name = format("ngw-ip-%s-%s-%s", "${var.vpc_name}", "${var.tags["Environment"]}", "${var.vpc_azs[count.index]}") }, var.tags)

}

resource "aws_nat_gateway" "ngw" {
  count         = var.num_az
  allocation_id = aws_eip.ngw_eip[count.index].id
  subnet_id     = var.public_subnet_ids[count.index]
  depends_on    = [aws_internet_gateway.igw]
  tags          = merge({ Name = format("ngw-%s-%s-%s", "${var.vpc_name}", "${var.tags["Environment"]}", "${var.vpc_azs[count.index]}") }, var.tags)
}
