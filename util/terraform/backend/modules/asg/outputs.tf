output "asg_name" {
  value = aws_autoscaling_group.this.name
}

output "previous_version" {
  description = "Previous version tag from existing instances"
  value       = local.previous_version
}

output "previous_desired_capacity" {
  description = "Previous desired capacity from existing ASG"
  value       = local.previous_desired_capacity
}

