variable "aws_region" {}
variable "environment" {}
variable "vpc_id" {}
variable "public_subnet_ids" { type = list(string) }
variable "domain_root" {}
variable "route53_zone_id" {}
variable "route53_record_name" {}
variable "ami_id" {}
variable "key_name" {}
variable "instance_type" {}

variable "active_environment" {
  description = "Active environment for traffic routing (blue or green)"
  type        = string
  validation {
    condition     = contains(["blue", "green"], var.active_environment)
    error_message = "Active environment must be either 'blue' or 'green'."
  }
}

variable "desired_capacity" {
  description = "Desired capacity for active environment"
  type        = number
  default     = 2
}

variable "blue_version" {
  description = "Application version for blue environment"
  type        = string
}

variable "green_version" {
  description = "Application version for green environment"
  type        = string
}

