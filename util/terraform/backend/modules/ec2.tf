resource "aws_instance" "anyhasher_server" {
  ami           = "ami-068663a3c619dd892"
  instance_type = "t2.micro"
  key_name = "pearson1"

  tags = {
    Name = var.instance_name,
    MadeWith = "Terraform"
  }
}

variable "instance_name" {
  description = "Terraform EC2 instance name"
}

variable "public_key" {
  description = "Terraform EC2 instance key pair"
}

output "ec2_public_ip" {
  value = aws_instance.anyhasher_server.public_ip
}

