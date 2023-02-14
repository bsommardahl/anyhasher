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
    key    = "anyhasher-fe.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "router" {
  source = "./modules/cloudfront"
  s3_endpoint = var.s3_endpoint
}

variable "s3_endpoint" {
  description = "specifies the DNS domain name of the origin"
}

variable "origin_id" {
  description = "specifies a unique identifier for the origin"
}

output "website_url" {
  value = module.router.domain_name
}