output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_zone_id" {
  value = aws_lb.this.zone_id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "production_target_group_arn" {
  value = aws_lb_target_group.production.arn
}

output "canary_target_group_arn" {
  value = var.canary_enabled ? aws_lb_target_group.canary[0].arn : null
}