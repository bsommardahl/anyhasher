# Get current production ASG information
data "aws_autoscaling_groups" "production_existing" {
  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
  filter {
    name   = "tag:DeploymentType"
    values = ["production"]
  }
}

data "aws_autoscaling_groups" "canary_existing" {
  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
  filter {
    name   = "tag:DeploymentType"
    values = ["canary"]
  }
}

data "aws_lb_listener" "https" {
  count = local.production_asg_exists ? 1 : 0
  load_balancer_arn = var.alb_arn
  port              = 443
}

data "aws_autoscaling_group" "production_current" {
  count = length(data.aws_autoscaling_groups.production_existing.names) > 0 ? 1 : 0
  name  = "anyhasher-${var.environment}-production"
}

data "aws_autoscaling_group" "canary_current" {
  count = length(data.aws_autoscaling_groups.canary_existing.names) > 0 ? 1 : 0
  name  = "anyhasher-${var.environment}-canary"
}

data "aws_instances" "production_current" {
  count = local.production_asg_exists ? 1 : 0
  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
  filter {
    name   = "tag:DeploymentType"
    values = ["production"]
  }
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

data "aws_instances" "canary_current" {
  count = local.canary_asg_exists ? 1 : 0
  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
  filter {
    name   = "tag:DeploymentType"
    values = ["canary"]
  }
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

data "aws_instance" "production_first" {
  count       = local.production_asg_exists ? 1 : 0
  instance_id = data.aws_instances.production_current[0].ids[0]
}

data "aws_instance" "canary_first" {
  count       = local.canary_asg_exists ? 1 : 0
  instance_id = data.aws_instances.canary_current[0].ids[0]
}

locals {
  production_asg_exists = contains(data.aws_autoscaling_groups.production_existing.names, "anyhasher-${var.environment}-production")
  canary_asg_exists = contains(data.aws_autoscaling_groups.canary_existing.names, "anyhasher-${var.environment}-canary")
  previous_production_version = local.production_asg_exists && length(data.aws_instance.production_first) > 0 ? lookup(data.aws_instance.production_first[0].tags, "Version", var.ver) : "first-deployment"
  previous_canary_version = local.canary_asg_exists && length(data.aws_instance.canary_first) > 0 ? lookup(data.aws_instance.canary_first[0].tags, "Version", var.ver) : "first-deployment"
  previous_production_desired_capacity = local.production_asg_exists && length(data.aws_autoscaling_group.production_current) > 0 ? data.aws_autoscaling_group.production_current[0].desired_capacity : 0
  previous_canary_desired_capacity = local.canary_asg_exists && length(data.aws_autoscaling_group.canary_current) > 0 ? data.aws_autoscaling_group.canary_current[0].desired_capacity : 0
  previous_canary_percentage = try(
    [for action in data.aws_lb_listener.https[0].default_action :
      length(action.forward) > 0 && length(tolist(action.forward[0].target_group)) > 1 ?
      tolist(action.forward[0].target_group)[0].weight : 0
      if action.type == "forward"
    ][0],
    0
  )
}
