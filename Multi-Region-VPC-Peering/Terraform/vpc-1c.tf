# Create VPC 1C (Ohio Region)
resource "aws_vpc" "vpc_1c" {
  provider              = aws.secondary
  cidr_block           = "172.16.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC-1C"
  }
}

# Create Internet Gateway 1C
resource "aws_internet_gateway" "igw_1c" {
  provider = aws.secondary
  vpc_id   = aws_vpc.vpc_1c.id

  tags = {
    Name = "IGW-1C"
  }
}

# Create Public Subnet 1C
resource "aws_subnet" "public_1c" {
  provider                = aws.secondary
  vpc_id                  = aws_vpc.vpc_1c.id
  cidr_block              = "172.16.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-1C"
  }
}

# Create Private Subnet 1C
resource "aws_subnet" "private_1c" {
  provider          = aws.secondary
  vpc_id            = aws_vpc.vpc_1c.id
  cidr_block        = "172.16.2.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "Private-Subnet-1C"
  }
}

# Create EIP for NAT-Gateway-1C
resource "aws_eip" "nat_eip_1c" {
  provider = aws.secondary
  domain   = "vpc"

  tags = {
    Name = "NAT-EIP-1C"
  }
}

# Create NAT Gateway 1C
resource "aws_nat_gateway" "nat_1c" {
  provider      = aws.secondary
  subnet_id     = aws_subnet.public_1c.id
  allocation_id = aws_eip.nat_eip_1c.id

  tags = {
    Name = "NAT-Gateway-1C"
  }
}

# Create Public Route Table 1C
resource "aws_route_table" "public_rt_1c" {
  provider = aws.secondary
  vpc_id   = aws_vpc.vpc_1c.id

# Specify Routes
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_1c.id
  }

  tags = {
    Name = "Public-RT-1C"
  }
}

# Associate Public RT to Public Subnet 1C
resource "aws_route_table_association" "public_assoc_1c" {
  provider       = aws.secondary
  subnet_id      = aws_subnet.public_1c.id
  route_table_id = aws_route_table.public_rt_1c.id
}

# Create Private Route Table 1C
resource "aws_route_table" "private_rt_1c" {
  provider = aws.secondary
  vpc_id   = aws_vpc.vpc_1c.id

# Specify Routes
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1c.id
  }

# Create Routes for VPC-A in VPC-C
  route {
    cidr_block = "10.75.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.peering_1a_to_1c.id
  }

# Create Routes for VPC-B in VPC-C
  route {
    cidr_block = "192.168.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.peering_1b_to_1c.id
  }

  tags = {
    Name = "Private-RT-1C"
  }
}

# Associate Private RT to Private Subnet 1C
resource "aws_route_table_association" "private_assoc_1c" {
  provider       = aws.secondary
  subnet_id      = aws_subnet.private_1c.id
  route_table_id = aws_route_table.private_rt_1c.id
}