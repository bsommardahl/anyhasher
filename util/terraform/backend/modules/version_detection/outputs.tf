output "production_asg_exists" {
  description = "Whether production ASG exists"
  value       = local.production_asg_exists
}

output "canary_asg_exists" {
  description = "Whether canary ASG exists"
  value       = local.canary_asg_exists
}

output "previous_production_version" {
  description = "Previous version running in production"
  value       = local.previous_production_version
}

output "previous_canary_version" {
  description = "Previous version running in canary"
  value       = local.previous_canary_version
}

output "previous_production_desired_capacity" {
  description = "Previous desired capacity for production ASG"
  value       = local.previous_production_desired_capacity
}

output "previous_canary_desired_capacity" {
  description = "Previous desired capacity for canary ASG"
  value       = local.previous_canary_desired_capacity
}

output "previous_canary_percentage" {
  description = "Previous canary traffic percentage"
  value       = local.previous_canary_percentage
}
