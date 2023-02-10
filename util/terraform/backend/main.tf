terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
  
  backend "s3" {
    bucket = "anyhasher.terraform.states"
    key    = "anyhasher-be.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "ec2" {
  source = "./modules/ec2"
  instance_name = var.instance_name
}

variable "instance_name" {
  description = "EC2 instance name"
}

output "ec2_public_ip" {
  value = module.ec2.ec2_public_ip
}

output "ec2_public_url" {
  value = module.ec2.ec2_public_url
}