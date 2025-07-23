output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.bluegreen_alb.alb_dns_name
}

output "blue_asg_name" {
  description = "Name of the Blue Auto Scaling Group"
  value       = module.blue_asg.asg_name
}

output "green_asg_name" {
  description = "Name of the Green Auto Scaling Group"
  value       = module.green_asg.asg_name
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for artifacts"
  value       = aws_s3_bucket.artifacts.bucket
}

output "active_environment" {
  description = "Currently active environment"
  value       = var.active_environment
}

output "blue_version" {
  description = "Version deployed to blue environment"
  value       = var.blue_version
}

output "green_version" {
  description = "Version deployed to green environment"
  value       = var.green_version
}
