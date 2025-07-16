variable "environment" {}
variable "vpc_id" {}
variable "public_subnet_ids" { type = list(string) }
variable "domain_root" {}
variable "route53_zone_id" {}
variable "route53_record_name" {}

variable "canary_enabled" {
  description = "Enable canary deployment strategy"
  type        = bool
  default     = false
}

variable "canary_traffic_percentage" {
  description = "Percentage of traffic to route to canary deployment"
  type        = number
  default     = 10
}