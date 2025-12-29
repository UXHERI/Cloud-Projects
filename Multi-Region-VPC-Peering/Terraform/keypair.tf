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