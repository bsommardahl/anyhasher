variable "environment" {}
variable "vpc_id" {}
variable "public_subnet_ids" { type = list(string) }
variable "domain_root" {}
variable "route53_zone_id" {}
variable "route53_record_name" {}

variable "use_green_environment" {
  description = "Whether to create green environment resources"
  type        = bool
  default     = false
}
