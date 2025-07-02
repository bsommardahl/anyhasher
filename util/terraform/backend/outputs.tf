output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "target_group_arn" {
  value = module.alb.target_group_arn
}

output "asg_name" {
  value = module.asg.asg_name
}

output "desired_capacity" {
  value = var.desired_capacity
}

output "previous_version" {
  description = "Previous version before deployment"
  value       = module.asg.previous_version
}
