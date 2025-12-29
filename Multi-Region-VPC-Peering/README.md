
# Multi-Region VPC Peering

In this **AWS Networking** project I'm going to show you how I built a **Multi-Region VPC Peering** all automated with **Terraform**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Multi-Region-VPC-Peering/Images/Architecture.png?raw=true)

This project will guide you with hands-on experience of how you can make a **VPC Peering** connection in multiple **AWS Regions** automatically with **Terraform**.

## Step-by-Step Project Guide

- Provisioning VPCs and EC2 Instances
- Creating VPC Peering Connections
- Modifying Route Tables
- Testing the VPC Peering connections

## 1. Provisioning VPCs and EC2 Instances

First, I'll be creating **3 VPCs** and launching one **Public** and one **Private** instances in each.

- Create a `terraform.tf`:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "secondary"
  region = "us-east-2"
}
```

- Create `vpc-1a.tf`:

```hcl
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

  tags = {
    Name = "Private-RT-1A"
  }
}

# Associate Private RT to Private Subnet 1A 
resource "aws_route_table_association" "private_assoc_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private_rt_1a.id
}
```

- Create `vpc-1b.tf`:

```hcl
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

  tags = {
    Name = "Private-RT-1B"
  }
}

# Associate Private RT to Private Subnet 1B
resource "aws_route_table_association" "private_assoc_1b" {
  subnet_id      = aws_subnet.private_1b.id
  route_table_id = aws_route_table.private_rt_1b.id
}
```

- Create `vpc-1c.tf`:

```hcl
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
```

- Create `keypair.tf`:

```hcl
# Generate RSA Key Pair for VPC Peering
resource "tls_private_key" "vpc_peering_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS Key Pair
resource "aws_key_pair" "vpc_peering" {
  key_name   = "VPC-Peering"
  public_key = tls_private_key.vpc_peering_key.public_key_openssh

  tags = {
    Name = "VPC-Peering-Key"
  }
}

# Save Private Key Locally as VPC-Peering.pem
resource "local_file" "vpc_peering_pem" {
  content              = tls_private_key.vpc_peering_key.private_key_pem
  filename             = "VPC-Peering.pem"
  file_permission      = "0400"
}
```

- Create `keypair-1c.tf`:

```hcl
# Generate RSA Key Pair for VPC Peering
resource "tls_private_key" "vpc_peering_1c_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS Key Pair
resource "aws_key_pair" "vpc_peering_1c" {
  key_name   = "VPC-Peering-1C"
  public_key = tls_private_key.vpc_peering_1c_key.public_key_openssh

  tags = {
    Name = "VPC-Peering-1C-Key"
  }
}

# Save Private Key Locally as VPC-Peering-1C.pem
resource "local_file" "vpc_peering_1c_pem" {
  content         = tls_private_key.vpc_peering_1c_key.private_key_pem
  filename        = "VPC-Peering-1C.pem"
  file_permission = "0400"
}
```

- Create `vpc-1a-sg.tf`:

```hcl
# Security Group for VPC-1A
resource "aws_security_group" "vpc_1a_sg" {
  name        = "vpc-1a-sg"
  description = "Allow SSH and ICMP from anywhere"
  vpc_id      = aws_vpc.vpc_1a.id

# Allow SSH
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# Allow ICMP (Ping)
  ingress {
    description = "ICMP access"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "VPC-1A-SG"
  }
}
```

- Create `vpc-1b-sg.tf`:

```hcl
# Security Group for VPC-1B
resource "aws_security_group" "vpc_1b_sg" {
  name        = "vpc-1b-sg"
  description = "Allow SSH and ICMP from anywhere"
  vpc_id      = aws_vpc.vpc_1b.id

# Allow SSH
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# Allow ICMP (Ping)
  ingress {
    description = "ICMP access"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "VPC-1B-SG"
  }
}
```

- Create `vpc-1c-sg.tf`:

```hcl
# Security Group for VPC-1A
resource "aws_security_group" "vpc_1c_sg" {
  provider = aws.secondary
  name        = "vpc-1a-sg"
  description = "Allow SSH and ICMP from anywhere"
  vpc_id      = aws_vpc.vpc_1c.id

# Allow SSH
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# Allow ICMP (Ping)
  ingress {
    description = "ICMP access"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "VPC-1C-SG"
  }
}
```

- Create `ec2-1a.tf`:

```hcl
# Creating Jump Server for VPC-1A
resource "aws_instance" "jump_server_1a" {
  ami = "ami-00ca32bbc84273381"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_1a.id
  key_name = aws_key_pair.vpc_peering.key_name
  vpc_security_group_ids = [aws_security_group.vpc_1a_sg.id]

  tags = {
    Name = "Jump-Server-1A"
  }
}

# Creating Private EC2-1A
resource "aws_instance" "private_ec2_1a" {
  ami = "ami-00ca32bbc84273381"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_1a.id
  key_name = aws_key_pair.vpc_peering.key_name
  vpc_security_group_ids = [aws_security_group.vpc_1a_sg.id]

  tags = {
    Name = "Private-EC2-1A"
  }
}
```

- Create `ec2-1b.tf`:

```hcl
# Creating Jump Server for VPC-1B
resource "aws_instance" "jump_server_1b" {
  ami = "ami-00ca32bbc84273381"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_1b.id
  key_name = aws_key_pair.vpc_peering.key_name
  vpc_security_group_ids = [aws_security_group.vpc_1b_sg.id]

  tags = {
    Name = "Jump-Server-1B"
  }
}

# Creating Private EC2-1B
resource "aws_instance" "private_ec2_1b" {
  ami = "ami-00ca32bbc84273381"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_1b.id
  key_name = aws_key_pair.vpc_peering.key_name
  vpc_security_group_ids = [aws_security_group.vpc_1b_sg.id]

  tags = {
    Name = "Private-EC2-1B"
  }
}
```

- Create `ec2-1c.tf`:

```hcl
# Creating Jump Server for VPC-1C
resource "aws_instance" "jump_server_1c" {
  provider = aws.secondary
  ami = "ami-00e428798e77d38d9"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_1c.id
  key_name = aws_key_pair.vpc_peering_1c.key_name
  vpc_security_group_ids = [aws_security_group.vpc_1c_sg.id]

  tags = {
    Name = "Jump-Server-1C"
  }
}

# Creating Private EC2-1C
resource "aws_instance" "private_ec2_1c" {
  provider = aws.secondary
  ami = "ami-00e428798e77d38d9"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_1c.id
  key_name = aws_key_pair.vpc_peering_1c.key_name
  vpc_security_group_ids = [aws_security_group.vpc_1c_sg.id]

  tags = {
    Name = "Private-EC2-1C"
  }
}
```

- Now apply these to provision the infrastructure:

```bash
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```
_This will create these resources._

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Multi-Region-VPC-Peering/Images/1.png?raw=true)

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Multi-Region-VPC-Peering/Images/2.png?raw=true)

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Multi-Region-VPC-Peering/Images/3.png?raw=true)

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Multi-Region-VPC-Peering/Images/4.png?raw=true)

## 2. Creating VPC Peering Connections

Now I'll create **3 VPC Peering** connections between these VPCs.

- Create `vpc-1a-to-1b.tf`:

```hcl
# Create VPC Peering Connection: VPC-1A to VPC-1B
resource "aws_vpc_peering_connection" "peering_1a_to_1b" {
  vpc_id      = aws_vpc.vpc_1a.id
  peer_vpc_id = aws_vpc.vpc_1b.id
  auto_accept = true

  tags = {
    Name = "VPC-1A-to-1B"
  }
}
```

- Create `vpc-1b-to-1c.tf`:

```hcl
# Create VPC Peering Connection: VPC-1B to VPC-1C
resource "aws_vpc_peering_connection" "peering_1b_to_1c" {
  vpc_id      = aws_vpc.vpc_1b.id
  peer_vpc_id = aws_vpc.vpc_1c.id
  peer_region = "us-east-2"
  auto_accept = false

  tags = {
    Name = "VPC-1B-to-1C"
  }
}
```

- Create `vpc-1a-to-1c.tf`:

```hcl
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
```

- Now apply again to create these connections:

```bash
terraform plan
terraform apply -auto-approve
```

_This will create these **VPC Peering** connections, you just have to accept both in `us-east-2`._

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Multi-Region-VPC-Peering/Images/6.png?raw=true)

## 3. Modifying Route Tables

The last step is to modify the **Route Tables** in each **VPC** file.

- Update the `vpc-1a.tf` file as:

```hcl
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
```

- Update the `vpc-1b.tf` file as:

```hcl
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
```

- Update the `vpc-1c.tf` file as:

```hcl
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
```

- Now apply again to make these changes:

```bash
terraform plan
terraform apply -auto-approve
```

_This will add these entries to the **Private Route Tables**._

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Multi-Region-VPC-Peering/Images/8.png?raw=true)

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Multi-Region-VPC-Peering/Images/9.png?raw=true)

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Multi-Region-VPC-Peering/Images/10.png?raw=true)

## 4. Testing the VPC Peering connections

Now, let's test these **VPC Connections** by simply **Pinging** the private instances from each other.

- First, ping `Private-EC2-1B` from **Private-EC2-1A**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Multi-Region-VPC-Peering/Images/11.png?raw=true)

- Now ping `Private-EC2-1C` from **Private-EC2-1A**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Multi-Region-VPC-Peering/Images/12.png?raw=true)

_Now each private intsnace can communicate with each other via the **VPC Peering** connections privately even though they are in different **AWS Regions**._ 
