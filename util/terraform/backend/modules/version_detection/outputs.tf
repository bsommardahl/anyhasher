output "production_asg_exists" {
  description = "Whether production ASG exists"
  value       = local.production_asg_exists
}

output "canary_asg_exists" {
  description = "Whether canary ASG exists"
  value       = local.canary_asg_exists
}

output "current_production_version" {
  description = "Current version running in production"
  value       = local.current_production_version
}

output "current_canary_version" {
  description = "Current version running in canary"
  value       = local.current_canary_version
}

output "current_production_desired_capacity" {
  description = "Current desired capacity for production ASG"
  value       = local.current_production_desired_capacity
}

output "current_canary_desired_capacity" {
  description = "Current desired capacity for canary ASG"
  value       = local.current_canary_desired_capacity
}

output "current_canary_percentage" {
  description = "Current canary traffic percentage"
  value       = local.current_canary_percentage
}
