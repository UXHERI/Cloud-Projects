resource "aws_internet_gateway" "igw_1a" {
  vpc_id = aws_vpc.vpc_1a.id

  tags = {
    Name = "IGW-VPC-1a"
  }
}

resource "aws_internet_gateway" "igw_1b" {
  vpc_id = aws_vpc.vpc_1b.id

  tags = {
    Name = "IGW-VPC-1b"
  }
}
