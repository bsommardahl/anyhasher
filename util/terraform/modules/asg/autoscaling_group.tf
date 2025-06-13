resource "aws_autoscaling_group" "this" {
  // name = "anyhasher-${var.environment}-${var.version}"
  desired_capacity     = 2
  max_size             = 4
  min_size             = 2
  vpc_zone_identifier  = var.public_subnet_ids
  target_group_arns    = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tags = [
    {
      key                 = "Version"
      value               = var.version
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "anyhasher-${var.environment}-${var.version}"
      propagate_at_launch = true
    }
  ]
}