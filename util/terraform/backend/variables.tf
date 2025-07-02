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
    condition     = contains(["scale_up", "rolling"], var.deployment_phase)
    error_message = "deployment_phase must be either 'scale_up' or 'rolling'"
  }
}

variable "desired_capacity" {
  description = "Normal desired capacity"
  type        = number
  default     = 2
}
