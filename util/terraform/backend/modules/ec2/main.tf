resource "aws_instance" "anyhasher_server" {
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.small"
  key_name      = "anyhasher"
  tags          = { 
    Name = var.instance_name 
    Environment = "Production"
    Layer = "Backend"
  }
}

variable "instance_name" {
  description = "EC2 instance name"
}

output "ec2_public_ip" {
  value = aws_instance.anyhasher_server.public_ip
}

output "ec2_public_host" {
  value = aws_instance.anyhasher_server.public_dns
}

