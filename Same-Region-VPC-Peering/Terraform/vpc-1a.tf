resource "aws_vpc" "vpc_1a" {
  cidr_block = "10.75.0.0/16"
  tags = {
    Name = "VPC-1a"
  }
}

resource "aws_subnet" "public_1a" {
  vpc_id            = aws_vpc.vpc_1a.id
  cidr_block        = "10.75.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-1a"
  }
}

resource "aws_subnet" "private_1a" {
  vpc_id            = aws_vpc.vpc_1a.id
  cidr_block        = "10.75.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private-Subnet-1a"
  }
}
