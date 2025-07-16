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
variable "ver" {
  description = "Git version or tag for this deployment"
  type        = string
}

# Canary deployment variables
variable "canary_enabled" {
  description = "Enable canary deployment strategy"
  type        = bool
  default     = false
}

variable "canary_traffic_percentage" {
  description = "Percentage of traffic to route to canary deployment"
  type        = number
  default     = 10
  
  validation {
    condition     = var.canary_traffic_percentage >= 0 && var.canary_traffic_percentage <= 50
    error_message = "Canary traffic percentage must be between 1 and 50."
  }
}

variable "production_desired_capacity" {
  description = "Desired capacity for production ASG"
  type        = number
  default     = 2
}

variable "canary_desired_capacity" {
  description = "Desired capacity for canary ASG"
  type        = number
  default     = 1
}
