resource "aws_instance" "hashing_app_server" {
  ami           = "ami-068663a3c619dd892"
  instance_type = "t2.micro"
  key_name = "hashing_app_server_key"

  tags = {
    Name = var.instance_name,
    MadeWith = "Terraform"
  }
}

resource "aws_key_pair" "hashing_app_server_key" {
  key_name   = "hashing_app_server_key"
  public_key = var.public_key
}
