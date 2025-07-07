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
variable "deployment_phase" {
  description = "Phase of deployment: scale_up or rolling"
  type        = string
  default     = "scale_up"
  validation {
    condition     = contains(["scale_up", "rolling", "rollback"], var.deployment_phase)
    error_message = "deployment_phase must be either 'scale_up', 'rolling' or 'rollback'"
  }
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
