terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"  
}

provider "aws" {
  region = "us-east-1"
}

module "s3" {
  source = "./modules/s3"
  bucket_name = var.bucket_name
}

variable "bucket_name" {
  description = "Website bucket name"
}

output "website_endpoint" {
  value = module.s3.website_endpoint
}

output "bucket_name" {
  value = module.s3.bucket_name
}

