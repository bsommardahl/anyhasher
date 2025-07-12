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

variable "desired_capacity" {
  description = "Normal desired capacity"
  type        = number
  default     = 2
}

variable "rollout_duration_seconds" {
  description = "Total duration for the rolling deployment to complete, including all verification pauses"
  type        = number
  default     = 60

  validation {
    condition     = var.rollout_duration_seconds >= 30
    error_message = "Rollout duration must be at least 30 seconds."
  }
}

variable "instance_warmup" {
  description = "Time to wait after each instance becomes healthy before proceeding to next instance in rolling deployment (in seconds)"
  type        = number
  default     = 60

  validation {
    condition     = var.instance_warmup >= 0 && var.instance_warmup <= 3600
    error_message = "Instance warmup must be between 0 and 3600 seconds (1 hour)."
  }
}

variable "min_healthy_percentage" {
  description = "Minimum percentage of instances that must remain healthy during rolling deployment. Lower values allow faster deployments but higher risk. Higher values are safer but slower."
  type        = number
  default     = 50

  validation {
    condition     = var.min_healthy_percentage >= 0 && var.min_healthy_percentage <= 100
    error_message = "Minimum healthy percentage must be between 0 and 100."
  }

  validation {
    condition     = var.min_healthy_percentage % 10 == 0
    error_message = "Minimum healthy percentage should be a multiple of 10 for better predictability (e.g., 50, 60, 90)."
  }
}
