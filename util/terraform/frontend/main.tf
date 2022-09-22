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
    key    = "anyhasher.hashingapp.api.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "ec2" {
  source = "./modules/ec2"
  instance_name = "AnyHasherServerInstance"
  public_key = var.public_key
}

module "s3" {
  source = "./modules/s3"
  bucket_name = "frontend.anyhasher.io"
}
