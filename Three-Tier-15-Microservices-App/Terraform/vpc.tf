# Creating VPC
resource "aws_vpc" "three_tier_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "3-tier-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.three_tier_vpc.id

  tags = {
    Name = "3-tier-igw"
  }
}

# Public Subnets
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.three_tier_vpc.id
  cidr_block              = "10.75.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-1a"
  }
}

resource "aws_subnet" "public_1b" {
  vpc_id                  = aws_vpc.three_tier_vpc.id
  cidr_block              = "10.75.2.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-1b"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id                  = aws_vpc.three_tier_vpc.id
  cidr_block              = "10.75.3.0/24"
  availability_zone       = "${var.aws_region}c"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-1c"
  }
}

# Web Private Subnets
resource "aws_subnet" "web_private_1a" {
  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = "10.75.4.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "Web-Private-Subnet-1a"
  }
}

resource "aws_subnet" "web_private_1b" {
  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = "10.75.5.0/24"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "Web-Private-Subnet-1b"
  }
}

resource "aws_subnet" "web_private_1c" {
  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = "10.75.6.0/24"
  availability_zone = "${var.aws_region}c"

  tags = {
    Name = "Web-Private-Subnet-1c"
  }
}

# App Private Subnets
resource "aws_subnet" "app_private_1a" {
  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = "10.75.7.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "App-Private-Subnet-1a"
  }
}

resource "aws_subnet" "app_private_1b" {
  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = "10.75.8.0/24"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "App-Private-Subnet-1b"
  }
}

resource "aws_subnet" "app_private_1c" {
  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = "10.75.9.0/24"
  availability_zone = "${var.aws_region}c"

  tags = {
    Name = "App-Private-Subnet-1c"
  }
}

# DB Private Subnets
resource "aws_subnet" "db_private_1a" {
  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = "10.75.10.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "DB-Private-Subnet-1a"
  }
}

resource "aws_subnet" "db_private_1b" {
  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = "10.75.11.0/24"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "DB-Private-Subnet-1b"
  }
}

resource "aws_subnet" "db_private_1c" {
  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = "10.75.12.0/24"
  availability_zone = "${var.aws_region}c"

  tags = {
    Name = "DB-Private-Subnet-1c"
  }
}

# NAT Gateways
resource "aws_eip" "nat_1a" {
  domain = "vpc"
}

resource "aws_eip" "nat_1b" {
  domain = "vpc"
}

resource "aws_eip" "nat_1c" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_1a" {
  allocation_id = aws_eip.nat_1a.id
  subnet_id     = aws_subnet.public_1a.id

  tags = {
    Name = "3-tier-1a"
  }
}

resource "aws_nat_gateway" "nat_1b" {
  allocation_id = aws_eip.nat_1b.id
  subnet_id     = aws_subnet.public_1b.id

  tags = {
    Name = "3-tier-1b"
  }
}

resource "aws_nat_gateway" "nat_1c" {
  allocation_id = aws_eip.nat_1c.id
  subnet_id     = aws_subnet.public_1c.id

  tags = {
    Name = "3-tier-1c"
  }
}

# Route Tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "3-tier-Public-rt"
  }
}

resource "aws_route_table" "web_private_rt_1a" {
  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1a.id
  }

  tags = {
    Name = "3-tier-web-Private-rt-1a"
  }
}

resource "aws_route_table" "web_private_rt_1b" {
  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1b.id
  }

  tags = {
    Name = "3-tier-web-Private-rt-1b"
  }
}

resource "aws_route_table" "web_private_rt_1c" {
  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1c.id
  }

  tags = {
    Name = "3-tier-web-Private-rt-1c"
  }
}

resource "aws_route_table" "app_private_rt_1a" {
  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1a.id
  }

  tags = {
    Name = "3-tier-app-Private-rt-1a"
  }
}

resource "aws_route_table" "app_private_rt_1b" {
  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1b.id
  }

  tags = {
    Name = "3-tier-app-Private-rt-1b"
  }
}

resource "aws_route_table" "app_private_rt_1c" {
  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1c.id
  }

  tags = {
    Name = "3-tier-app-Private-rt-1c"
  }
}

resource "aws_route_table" "db_private_rt_1a" {
  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1a.id
  }

  tags = {
    Name = "3-tier-db-Private-rt-1a"
  }
}

resource "aws_route_table" "db_private_rt_1b" {
  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1b.id
  }

  tags = {
    Name = "3-tier-db-Private-rt-1b"
  }
}

resource "aws_route_table" "db_private_rt_1c" {
  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1c.id
  }

  tags = {
    Name = "3-tier-db-Private-rt-1c"
  }
}

# Public Route Table Associations
resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_1b" {
  subnet_id      = aws_subnet.public_1b.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_1c" {
  subnet_id      = aws_subnet.public_1c.id
  route_table_id = aws_route_table.public_rt.id
}

# Web Tier Private Route Table Associations
resource "aws_route_table_association" "web_private_1a" {
  subnet_id      = aws_subnet.web_private_1a.id
  route_table_id = aws_route_table.web_private_rt_1a.id
}

resource "aws_route_table_association" "web_private_1b" {
  subnet_id      = aws_subnet.web_private_1b.id
  route_table_id = aws_route_table.web_private_rt_1b.id
}

resource "aws_route_table_association" "web_private_1c" {
  subnet_id      = aws_subnet.web_private_1c.id
  route_table_id = aws_route_table.web_private_rt_1c.id
}

# App Tier Private Route Table Associations
resource "aws_route_table_association" "app_private_1a" {
  subnet_id      = aws_subnet.app_private_1a.id
  route_table_id = aws_route_table.app_private_rt_1a.id
}

resource "aws_route_table_association" "app_private_1b" {
  subnet_id      = aws_subnet.app_private_1b.id
  route_table_id = aws_route_table.app_private_rt_1b.id
}

resource "aws_route_table_association" "app_private_1c" {
  subnet_id      = aws_subnet.app_private_1c.id
  route_table_id = aws_route_table.app_private_rt_1c.id
}

# DB Tier Private Route Table Associations
resource "aws_route_table_association" "db_private_1a" {
  subnet_id      = aws_subnet.db_private_1a.id
  route_table_id = aws_route_table.db_private_rt_1a.id
}

resource "aws_route_table_association" "db_private_1b" {
  subnet_id      = aws_subnet.db_private_1b.id
  route_table_id = aws_route_table.db_private_rt_1b.id
}

resource "aws_route_table_association" "db_private_1c" {
  subnet_id      = aws_subnet.db_private_1c.id
  route_table_id = aws_route_table.db_private_rt_1c.id
}
