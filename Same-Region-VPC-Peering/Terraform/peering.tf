resource "aws_vpc_peering_connection" "peer_1a_1b" {
  vpc_id      = aws_vpc.vpc_1a.id
  peer_vpc_id = aws_vpc.vpc_1b.id
  auto_accept = true

  tags = {
    Name = "VPC-1A-To-1B"
  }
}

## Route Tables VPC-1A
resource "aws_route_table" "rt_private_1a" {
  vpc_id = aws_vpc.vpc_1a.id

  tags = {
    Name = "RT-Private-1a"
  }
}

resource "aws_route" "route_1a_to_1b" {
  route_table_id         = aws_route_table.rt_private_1a.id
  destination_cidr_block = "192.168.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_1a_1b.id
}

resource "aws_route_table_association" "assoc_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.rt_private_1a.id
}

## Route Tables VPC-1B
resource "aws_route_table" "rt_private_1b" {
  vpc_id = aws_vpc.vpc_1b.id

  tags = {
    Name = "RT-Private-1b"
  }
}

resource "aws_route" "route_1b_to_1a" {
  route_table_id         = aws_route_table.rt_private_1b.id
  destination_cidr_block = "10.75.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_1a_1b.id
}

resource "aws_route_table_association" "assoc_1b" {
  subnet_id      = aws_subnet.private_1b.id
  route_table_id = aws_route_table.rt_private_1b.id
}
