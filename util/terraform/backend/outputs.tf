output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "target_group_arn" {
  value = module.alb.target_group_arn
}

output "asg_name" {
  value = module.asg.asg_name
}

output "desired_capacity" {
  value = var.desired_capacity
}

output "previous_version" {
  description = "Previous version before deployment"
  value       = module.asg.previous_version
}

output "previous_desired_capacity" {
  description = "Previous desired capacity before deployment"
  value       = module.asg.previous_desired_capacity
}

output "s3_bucket" {
  description = "S3 bucket name for artifacts"
  value       = aws_s3_bucket.artifacts.bucket
}
