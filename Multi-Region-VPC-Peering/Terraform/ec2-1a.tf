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