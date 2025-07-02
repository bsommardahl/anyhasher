variable "aws_region" {}
variable "environment" {}

variable "ver" {
  description = "Git version or tag for this deployment"
  type        = string
}

variable "route53_zone_id" {
  description = "Route53 zone ID for anyhasher.io"
  type        = string
}

