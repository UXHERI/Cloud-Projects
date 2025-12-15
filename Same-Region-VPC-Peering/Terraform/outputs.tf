output "jump_server_public_ip" {
  value = aws_instance.jump_server_1a.public_ip
}
