data "aws_autoscaling_groups" "existing" {
  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
}

data "aws_autoscaling_group" "current" {
  count = local.asg_exists ? 1 : 0
  name  = "anyhasher-${var.environment}"
}

data "aws_instances" "current" {
  count = local.asg_exists ? 1 : 0
  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

data "aws_instance" "first" {
  count       = local.asg_exists ? 1 : 0
  instance_id = data.aws_instances.current[0].ids[0]
}

locals {
  asg_exists                = contains(data.aws_autoscaling_groups.existing.names, "anyhasher-${var.environment}")
  previous_version          = local.asg_exists && length(data.aws_instance.first) > 0 ? lookup(data.aws_instance.first[0].tags, "Version", "unknown") : "first-deployment"
  previous_desired_capacity = local.asg_exists && length(data.aws_autoscaling_groups.existing.names) > 0 ? data.aws_autoscaling_group.current[0].desired_capacity : var.desired_capacity
}

resource "aws_autoscaling_group" "this" {
  name                = "anyhasher-${var.environment}"
  desired_capacity    = var.desired_capacity
  max_size            = var.desired_capacity * 2
  min_size            = var.desired_capacity
  vpc_zone_identifier = var.public_subnet_ids
  target_group_arns   = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage       = var.min_healthy_percentage
      checkpoint_delay             = var.checkpoint_wait
      checkpoint_percentages       = [50, 100]
      scale_in_protected_instances = "Ignore"
      skip_matching                = false
    }

    triggers = ["tag", "launch_template"]
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

