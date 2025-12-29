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