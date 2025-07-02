variable "environment" {}
variable "route53_zone_id" {}

variable "ver" {
  description = "Git version or tag for this deployment"
  type        = string
}
