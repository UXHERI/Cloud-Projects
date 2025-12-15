data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

## Jump Server 1A
resource "aws_instance" "jump_server_1a" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id              = aws_subnet.public_1a.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_icmp_1a.id]
  associate_public_ip_address = true

  tags = {
    Name = "Jump-Server-1a"
  }
}

## Private EC2 1A
resource "aws_instance" "private_ec2_1a" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id              = aws_subnet.private_1a.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_icmp_1a.id]

  tags = {
    Name = "Private-EC2-1a"
  }
}

## Private EC2 1B
resource "aws_instance" "private_ec2_1b" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id              = aws_subnet.private_1b.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_icmp_1b.id]

  tags = {
    Name = "Private-EC2-1b"
  }
}
