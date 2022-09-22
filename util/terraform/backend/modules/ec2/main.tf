resource "aws_instance" "anyhasher_server" {
  ami           = "ami-0149b2da6ceec4bb0"
  instance_type = "t2.micro"
  key_name      = "anyhasher"

  tags = {
    Name = var.instance_name,
    Purpose = "Course"
  }
}

variable "instance_name" {
  description = "Terraform EC2 instance name"
}

output "ec2_public_ip" {
  value = aws_instance.anyhasher_server.public_ip
}

