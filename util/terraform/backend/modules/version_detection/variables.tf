variable "environment" {
  description = "Environment name"
  type        = string
}

variable "ver" {
  description = "New version to deploy"
  type        = string
}

variable "alb_arn" {
  description = "ARN del Application Load Balancer"
  type        = string
}