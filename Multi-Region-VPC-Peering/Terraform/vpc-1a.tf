# Create VPC 1A
resource "aws_vpc" "vpc_1a" {
  cidr_block           = "10.75.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC-1A"
  }
}

# Create Internet Gateway 1A
resource "aws_internet_gateway" "igw_1a" {
  vpc_id = aws_vpc.vpc_1a.id

  tags = {
    Name = "IGW-1A"
  }
}

# Create Public Subnet 1A
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.vpc_1a.id
  cidr_block              = "10.75.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-1A"
  }
}

# Create Private Subnet 1A
resource "aws_subnet" "private_1a" {
  vpc_id            = aws_vpc.vpc_1a.id
  cidr_block        = "10.75.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private-Subnet-1A"
  }
}

# Create EIP for NAT-Gateway-1A
resource "aws_eip" "nat_eip_1a" {
  domain = "vpc"

  tags = {
    Name = "NAT-EIP-1A"
  }
}

# Create NAT Gateway 1A
resource "aws_nat_gateway" "nat_1a" {
  subnet_id     = aws_subnet.public_1a.id
  allocation_id = aws_eip.nat_eip_1a.id

  tags = {
    Name = "NAT-Gateway-1A"
  }
}

# Create Public Route Table
resource "aws_route_table" "public_rt_1a" {
  vpc_id = aws_vpc.vpc_1a.id

# Specify Routes
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_1a.id
  }

  tags = {
    Name = "Public-RT-1A"
  }
}

# Associate Public RT to Public Subnet 1A
resource "aws_route_table_association" "public_assoc_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public_rt_1a.id
}

# Create Private Route Table
resource "aws_route_table" "private_rt_1a" {
  vpc_id = aws_vpc.vpc_1a.id

# Specify Routes
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1a.id
  }

# Create Routes for VPC-B in VPC-A
  route {
    cidr_block = "192.168.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.peering_1a_to_1b.id
  }

# Create Routes for VPC-C in VPC-A
  route {
    cidr_block = "172.16.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.peering_1a_to_1c.id
  }  

  tags = {
    Name = "Private-RT-1A"
  }
}

# Associate Private RT to Private Subnet 1A 
resource "aws_route_table_association" "private_assoc_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private_rt_1a.id
}