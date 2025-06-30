variable "environment" {}
variable "ami_id" {}
variable "key_name" {}
variable "instance_type" {}
variable "target_group_arn" {}
variable "vpc_id" {}
variable "public_subnet_ids" { type = list(string) }
variable "alb_sg_id" {}
variable "desired_capacity" {}

variable "ver" {
  description = "Git version or tag for this deployment"
  type        = string
}

variable "deployment_phase" {
  description = "Phase of deployment: scale_up or rolling"
  type        = string
}

