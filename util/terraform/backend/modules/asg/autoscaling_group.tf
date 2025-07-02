data "aws_autoscaling_groups" "existing" {
  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
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
  count       = local.asg_exists && length(data.aws_instances.current[0].ids) > 0 ? 1 : 0
  instance_id = data.aws_instances.current[0].ids[0]
}

locals {
  asg_exists                 = contains(data.aws_autoscaling_groups.existing.names, "anyhasher-${var.environment}")
  should_scale_up            = local.asg_exists && var.deployment_phase == "scale_up"
  should_activate_rolling    = local.asg_exists && var.deployment_phase == "rolling"
  effective_desired_capacity = local.should_scale_up ? var.desired_capacity * 2 : var.desired_capacity
  termination_policy         = var.deployment_phase == "rolling" ? ["Default"] : ["NewestInstance", "Default"]

  previous_version = local.asg_exists && length(data.aws_instance.first) > 0 ? lookup(data.aws_instance.first[0].tags, "Version", "unknown") : "first-deployment"
}

resource "aws_autoscaling_group" "this" {
  name                 = "anyhasher-${var.environment}"
  desired_capacity     = local.effective_desired_capacity
  max_size             = var.desired_capacity * 2
  min_size             = var.desired_capacity
  vpc_zone_identifier  = var.public_subnet_ids
  target_group_arns    = [var.target_group_arn]
  termination_policies = local.termination_policy

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

