output "asg_name" {
  value = aws_autoscaling_group.this.name
}

output "previous_version" {
  description = "Previous version tag from existing instances"
  value       = local.previous_version
}

