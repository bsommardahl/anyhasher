output "ec2_public_ip" {
  value = aws_instance.hanyhasher_server.public_ip
}
