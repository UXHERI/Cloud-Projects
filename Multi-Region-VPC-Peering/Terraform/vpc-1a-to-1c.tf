# Create VPC Peering Connection: VPC-1A to VPC-1C
resource "aws_vpc_peering_connection" "peering_1a_to_1c" {
  vpc_id      = aws_vpc.vpc_1a.id
  peer_vpc_id = aws_vpc.vpc_1c.id
  peer_region = "us-east-2"
  auto_accept = false

  tags = {
    Name = "VPC-1A-to-1C"
  }
}