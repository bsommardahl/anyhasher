resource "aws_autoscaling_group" "this" {
  name = "anyhasher-${var.environment}-${var.ver}"
  desired_capacity     = 2
  max_size             = 4
  min_size             = 2
  vpc_zone_identifier  = var.public_subnet_ids
  target_group_arns    = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key = "Version"
    value = var.ver
    propagate_at_launch = true
  }
}