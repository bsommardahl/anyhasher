output "ec2_public_ip" {
  value = aws_instance.anyhasher_server.public_ip
}
