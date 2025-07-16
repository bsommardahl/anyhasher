output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "production_target_group_arn" {
  value = module.alb.production_target_group_arn
}

output "canary_target_group_arn" {
  value = module.alb.canary_target_group_arn
}

output "production_asg_name" {
  value = module.production_asg.asg_name
}

output "canary_asg_name" {
  value = var.canary_enabled ? module.canary_asg[0].asg_name : null
}

output "canary_enabled" {
  value = var.canary_enabled
}

output "canary_traffic_percentage" {
  value = var.canary_traffic_percentage
}

output "s3_bucket" {
  description = "S3 bucket name for artifacts"
  value       = aws_s3_bucket.artifacts.bucket
}
