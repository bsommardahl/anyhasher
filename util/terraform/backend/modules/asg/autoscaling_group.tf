locals {
  asg_name = "anyhasher-${var.environment}-${var.deployment_type}"
}

resource "aws_autoscaling_group" "this" {
  name                = local.asg_name
  desired_capacity    = var.desired_capacity
  max_size            = var.desired_capacity * 2
  min_size            = 0
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
      checkpoint_delay             = 60
      checkpoint_percentages       = [50, 100]
      scale_in_protected_instances = "Ignore"
      skip_matching                = false
    }
    triggers = ["launch_template"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

