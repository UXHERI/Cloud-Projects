resource "aws_vpc" "vpc_1b" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "VPC-1b"
  }
}

resource "aws_subnet" "private_1b" {
  vpc_id            = aws_vpc.vpc_1b.id
  cidr_block        = "192.168.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Private-Subnet-1b"
  }
}

resource "aws_subnet" "public_1b" {
  vpc_id                  = aws_vpc.vpc_1b.id
  cidr_block              = "192.168.1.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-1b"
  }
}
