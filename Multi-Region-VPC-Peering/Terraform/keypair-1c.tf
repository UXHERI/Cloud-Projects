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