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

variable "use_green_environment" {
  description = "Usage of green environment"
  type        = bool
  default     = false
}

variable "blue_desired_capacity" {
  description = "Desired capacity for blue environment"
  type        = number
  default     = 2
}

variable "green_desired_capacity" {
  description = "Desired capacity for green environment"
  type        = number
  default     = 1
}

variable "blue_version" {
  description = "Application version for blue environment"
  type        = string
  default     = null
}

variable "green_version" {
  description = "Application version for green environment"
  type        = string
  default     = null
}

