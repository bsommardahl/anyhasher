data "aws_autoscaling_groups" "existing" {
  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
}

locals {
  asg_exists                 = contains(data.aws_autoscaling_groups.existing.names, "anyhasher-${var.environment}")
  should_scale_up            = local.asg_exists && var.deployment_phase == "scale_up"
  should_activate_rolling    = local.asg_exists && var.deployment_phase == "rolling"
  effective_desired_capacity = local.should_scale_up ? var.desired_capacity * 2 : var.desired_capacity
}

resource "aws_autoscaling_group" "this" {
  name                = "anyhasher-${var.environment}"
  desired_capacity    = local.effective_desired_capacity
  max_size            = var.desired_capacity * 2
  min_size            = var.desired_capacity
  vpc_zone_identifier = var.public_subnet_ids
  target_group_arns   = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  dynamic "instance_refresh" {
    for_each = local.should_activate_rolling ? [1] : []
    content {
      strategy = "Rolling"

      preferences {
        min_healthy_percentage       = 75
        instance_warmup              = 300
        scale_in_protected_instances = "Ignore"
      }

      triggers = ["tag", "launch_template"]
    }
  }

  tag {
    key                 = "Version"
    value               = var.ver
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

