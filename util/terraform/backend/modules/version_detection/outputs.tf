output "blue_asg_exists" {
  description = "Whether blue ASG exists"
  value       = local.blue_asg_exists
}

output "green_asg_exists" {
  description = "Whether green ASG exists"
  value       = local.green_asg_exists
}

output "previous_blue_version" {
  description = "Previous version running in blue deployment"
  value       = local.previous_blue_version
}

output "previous_green_version" {
  description = "Previous version running in green deployment"
  value       = local.previous_green_version
}

output "previous_blue_desired_capacity" {
  description = "Previous desired capacity for blue ASG"
  value       = local.previous_blue_desired_capacity
}

output "previous_green_desired_capacity" {
  description = "Previous desired capacity for green ASG"
  value       = local.previous_green_desired_capacity
}

