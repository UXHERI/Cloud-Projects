# Create VPC Peering Connection: VPC-1A to VPC-1B
resource "aws_vpc_peering_connection" "peering_1a_to_1b" {
  vpc_id      = aws_vpc.vpc_1a.id
  peer_vpc_id = aws_vpc.vpc_1b.id
  auto_accept = true

  tags = {
    Name = "VPC-1A-to-1B"
  }
}