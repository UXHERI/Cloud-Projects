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