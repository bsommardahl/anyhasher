variable "environment" {}
variable "ami_id" {}
variable "key_name" {}
variable "instance_type" {}
variable "target_group_arn" {}
variable "vpc_id" {}
variable "public_subnet_ids" { type = list(string) }
variable "alb_sg_id" {}
variable "desired_capacity" {}

variable "deployment_color" {
  description = "Deployment color (blue or green)"
  type        = string
}

variable "ver" {
  description = "Git version or tag for this deployment"
  type        = string
}

variable "s3_bucket" {
  description = "S3 bucket name for artifacts"
  type        = string
}

variable "instance_profile_name" {
  description = "IAM instance profile name for EC2 instances"
  type        = string
}
