output "asg_name" {
  value = aws_autoscaling_group.this.name
}

output "asg_arn" {
  value = aws_autoscaling_group.this.arn
}

output "desired_capacity" {
  value = aws_autoscaling_group.this.desired_capacity
}
