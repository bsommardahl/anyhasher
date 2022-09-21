output "ec2_public_ip" {
  value = aws_instance.hashing_app_server.public_ip
}
