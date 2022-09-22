terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

variable "public_key" {
  description = "Terraform EC2 instance key pair"
}

provider "aws" {
  region = "us-east-1"
}

module "ec2" {
  source = "./modules/ec2.tf"
  instance_name = "AnyHasherServerInstance"
  public_key = var.public_key
}

output "ec2_public_ip" {
  value = module.ec2.ec2_public_ip
}

