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

output "previous_blue_version" {
  description = "Previous version running in blue deployment"
  value       = module.version_detection.previous_blue_version
}

output "previous_green_version" {
  description = "Previous version running in green deployment"
  value       = module.version_detection.previous_green_version
}

output "previous_blue_desired_capacity" {
  description = "Previous desired capacity for blue ASG"
  value       = module.version_detection.previous_blue_desired_capacity
}

output "previous_green_desired_capacity" {
  description = "Previous desired capacity for green ASG"
  value       = module.version_detection.previous_green_desired_capacity
}

output "blue_target_group_arn" {
  description = "ARN of the blue target group"
  value       = module.bluegreen_alb.blue_target_group_arn
}

output "green_target_group_arn" {
  description = "ARN of the green target group"
  value       = module.bluegreen_alb.green_target_group_arn
}
