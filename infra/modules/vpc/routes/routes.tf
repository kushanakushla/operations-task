########## Route table and Association ################

# Public
resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_id
  tags   = merge({ Name = format("public-route-%s-%s", "${var.vpc_name}", "${var.tags["Environment"]}") }, var.tags)
}

resource "aws_route" "public_route_inet" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id
}

resource "aws_route_table_association" "public_subnets" {
  count          = var.num_az
  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public_route_table.id
}

# Private
resource "aws_route_table" "private_route_table" {
  count  = var.num_az
  vpc_id = var.vpc_id
  tags   = merge({ Name = format("private-route-%s-%s-%s", "${var.vpc_name}", "${var.tags["Environment"]}", "${var.vpc_azs[count.index]}") }, var.tags)
}

resource "aws_route" "private_route_inet" {
  count                  = var.num_az
  depends_on             = [var.ngw_id]
  route_table_id         = aws_route_table.private_route_table[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.ngw_id[count.index]
}

resource "aws_route_table_association" "private_subnets" {
  count          = var.num_az
  subnet_id      = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private_route_table[count.index].id
}

resource "aws_route_table_association" "db_subnets" {
  count          = var.num_az
  subnet_id      = var.db_subnet_ids[count.index]
  route_table_id = aws_route_table.private_route_table[count.index].id
}
