output "blue_asg_exists" {
  description = "Whether blue ASG exists"
  value       = local.blue_asg_exists
}

output "previous_blue_version" {
  description = "Previous version running in blue deployment"
  value       = local.previous_blue_version
}

output "previous_blue_desired_capacity" {
  description = "Previous desired capacity for blue ASG"
  value       = local.previous_blue_desired_capacity
}
