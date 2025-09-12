# Creating a Key-Pair
resource "aws_key_pair" "three-tier-key" {
  key_name = "3-tier-key"
  public_key = file("3-tier-app.pub")
}

# Creating Jump Server for Web
resource "aws_instance" "jump_server_web" {
  ami = "ami-00ca32bbc84273381"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_1a.id
  key_name = aws_key_pair.three-tier-key.key_name
  vpc_security_group_ids = [aws_security_group.jump_server.id]

  tags = {
    Name = "jump-server-web"
  }
}

# Creating Jump Server for App
resource "aws_instance" "jump_server_app" {
  ami = "ami-00ca32bbc84273381"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_1a.id
  key_name = aws_key_pair.three-tier-key.key_name
  vpc_security_group_ids = [aws_security_group.jump_server.id]

  tags = {
    Name = "jump-server-app"
  }
}
