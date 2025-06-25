resource "aws_autoscaling_group" "this" {
  name                = "anyhasher-${var.environment}"
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  vpc_zone_identifier = var.public_subnet_ids
  target_group_arns   = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage       = 50
      instance_warmup              = 300
      scale_in_protected_instances = "Ignore"
    }

    triggers = ["tag", "launch_template"]
  }

  tag {
    key                 = "Version"
    value               = var.ver
    propagate_at_launch = true
  }
}

