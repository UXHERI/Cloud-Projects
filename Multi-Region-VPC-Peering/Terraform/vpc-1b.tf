# Create VPC 1B
resource "aws_vpc" "vpc_1b" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC-1B"
  }
}

# Create Internet Gateway 1B
resource "aws_internet_gateway" "igw_1b" {
  vpc_id = aws_vpc.vpc_1b.id

  tags = {
    Name = "IGW-1B"
  }
}

# Create Public Subnet 1B
resource "aws_subnet" "public_1b" {
  vpc_id                  = aws_vpc.vpc_1b.id
  cidr_block              = "192.168.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-1B"
  }
}

# Create Private Subnet 1B
resource "aws_subnet" "private_1b" {
  vpc_id            = aws_vpc.vpc_1b.id
  cidr_block        = "192.168.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private-Subnet-1B"
  }
}

# Create EIP for NAT-Gateway-1B
resource "aws_eip" "nat_eip_1b" {
  domain = "vpc"

  tags = {
    Name = "NAT-EIP-1B"
  }
}

# Create NAT Gateway 1B
resource "aws_nat_gateway" "nat_1b" {
  subnet_id     = aws_subnet.public_1b.id
  allocation_id = aws_eip.nat_eip_1b.id

  tags = {
    Name = "NAT-Gateway-1B"
  }
}

# Create Public Route Table
resource "aws_route_table" "public_rt_1b" {
  vpc_id = aws_vpc.vpc_1b.id

# Specify Routes
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_1b.id
  }

  tags = {
    Name = "Public-RT-1B"
  }
}

# Associate Public RT to Public Subnet 1B
resource "aws_route_table_association" "public_assoc_1b" {
  subnet_id      = aws_subnet.public_1b.id
  route_table_id = aws_route_table.public_rt_1b.id
}

# Create Private Route Table
resource "aws_route_table" "private_rt_1b" {
  vpc_id = aws_vpc.vpc_1b.id

# Specify Routes
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1b.id
  }

# Create Routes for VPC-A in VPC-B
  route {
    cidr_block = "10.75.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.peering_1a_to_1b.id
  }

# Create Routes for VPC-C in VPC-B
  route {
    cidr_block = "172.16.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.peering_1b_to_1c.id
  }  

  tags = {
    Name = "Private-RT-1B"
  }
}

# Associate Private RT to Private Subnet 1B
resource "aws_route_table_association" "private_assoc_1b" {
  subnet_id      = aws_subnet.private_1b.id
  route_table_id = aws_route_table.private_rt_1b.id
}