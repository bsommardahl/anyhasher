output "production_asg_exists" {
  description = "Whether production ASG exists"
  value       = local.production_asg_exists
}

output "current_production_version" {
  description = "Current version running in production"
  value       = local.current_production_version
}
