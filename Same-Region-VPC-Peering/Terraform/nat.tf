resource "aws_eip" "nat_eip_1a" {
  domain = "vpc"
}

resource "aws_eip" "nat_eip_1b" {
  domain = "vpc"
}

## NAT Gateway 1A
resource "aws_nat_gateway" "nat_1a" {
  allocation_id = aws_eip.nat_eip_1a.id
  subnet_id     = aws_subnet.public_1a.id

  tags = {
    Name = "NAT-1a"
  }

  depends_on = [aws_internet_gateway.igw_1a]
}

## NAT Gateway 1B
resource "aws_nat_gateway" "nat_1b" {
  allocation_id = aws_eip.nat_eip_1b.id
  subnet_id     = aws_subnet.public_1b.id

  tags = {
    Name = "NAT-1b"
  }

  depends_on = [aws_internet_gateway.igw_1b]
}

