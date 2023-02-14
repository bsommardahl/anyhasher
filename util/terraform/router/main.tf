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
  frontend_url = var.frontend_url
}

variable "frontend_url" {
  description = "Bucket URL for production version"
}

# output "website_endpoint" {
#   value = module.s3.website_endpoint
# }

# output "bucket_name" {
#   value = module.s3.bucket_name
# }

