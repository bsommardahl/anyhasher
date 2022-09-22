resource "aws_instance" "anyhasher_server" {
  ami           = "ami-068663a3c619dd892"
  instance_type = "t2.micro"
  key_name = "pearson1"

  tags = {
    Name = var.instance_name,
    MadeWith = "Terraform"
  }
}