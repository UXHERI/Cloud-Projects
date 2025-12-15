## Public RT 1A
resource "aws_route_table" "rt_public_1a" {
  vpc_id = aws_vpc.vpc_1a.id

  tags = {
    Name = "RT-Public-1a"
  }
}

resource "aws_route" "public_1a_igw" {
  route_table_id         = aws_route_table.rt_public_1a.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_1a.id
}

resource "aws_route_table_association" "public_assoc_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.rt_public_1a.id
}

## Public RT 1B
resource "aws_route_table" "rt_public_1b" {
  vpc_id = aws_vpc.vpc_1b.id
  
  tags = {
    Name = "RT-Public-1b"
  }
}

resource "aws_route" "public_1b_igw" {
  route_table_id         = aws_route_table.rt_public_1b.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_1b.id
}

resource "aws_route_table_association" "public_assoc_1b" {
  subnet_id      = aws_subnet.public_1b.id
  route_table_id = aws_route_table.rt_public_1b.id
}

## Private RT 1A
resource "aws_route" "private_1a_nat" {
  route_table_id         = aws_route_table.rt_private_1a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_1a.id
}

## Private RT 1B
resource "aws_route" "private_1b_nat" {
  route_table_id         = aws_route_table.rt_private_1b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_1b.id
}
