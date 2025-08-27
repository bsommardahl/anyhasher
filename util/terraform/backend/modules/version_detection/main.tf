data "aws_autoscaling_groups" "blue_existing" {
  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
  filter {
    name   = "tag:DeploymentColor"
    values = ["blue"]
  }
}

data "aws_autoscaling_groups" "green_existing" {
  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
  filter {
    name   = "tag:DeploymentColor"
    values = ["green"]
  }
}

data "aws_autoscaling_group" "blue_current" {
  count = length(data.aws_autoscaling_groups.blue_existing.names) > 0 ? 1 : 0
  name  = "anyhasher-${var.environment}-blue"
}

data "aws_autoscaling_group" "green_current" {
  count = length(data.aws_autoscaling_groups.green_existing.names) > 0 ? 1 : 0
  name  = "anyhasher-${var.environment}-green"
}

data "aws_instances" "blue_current" {
  count = local.blue_asg_exists ? 1 : 0
  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
  filter {
    name   = "tag:DeploymentColor"
    values = ["blue"]
  }
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

data "aws_instances" "green_current" {
  count = local.green_asg_exists ? 1 : 0
  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
  filter {
    name   = "tag:DeploymentColor"
    values = ["green"]
  }
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

data "aws_instance" "blue_first" {
  count       = local.blue_asg_exists && length(data.aws_instances.blue_current) > 0 && length(data.aws_instances.blue_current[0].ids) > 0 ? 1 : 0
  instance_id = data.aws_instances.blue_current[0].ids[0]
}

data "aws_instance" "green_first" {
  count       = local.green_asg_exists && length(data.aws_instances.green_current) > 0 && length(data.aws_instances.green_current[0].ids) > 0 ? 1 : 0
  instance_id = data.aws_instances.green_current[0].ids[0]
}

locals {
  blue_asg_exists                 = contains(data.aws_autoscaling_groups.blue_existing.names, "anyhasher-${var.environment}-blue")
  green_asg_exists                = contains(data.aws_autoscaling_groups.green_existing.names, "anyhasher-${var.environment}-green")
  previous_blue_version           = local.blue_asg_exists && length(data.aws_instance.blue_first) > 0 ? lookup(data.aws_instance.blue_first[0].tags, "Version", "first-deployment") : "first-deployment"
  previous_green_version          = local.green_asg_exists && length(data.aws_instance.green_first) > 0 ? lookup(data.aws_instance.green_first[0].tags, "Version", "first-deployment") : "first-deployment"
  previous_blue_desired_capacity  = local.blue_asg_exists && length(data.aws_autoscaling_group.blue_current) > 0 ? data.aws_autoscaling_group.blue_current[0].desired_capacity : 0
  previous_green_desired_capacity = local.green_asg_exists && length(data.aws_autoscaling_group.green_current) > 0 ? data.aws_autoscaling_group.green_current[0].desired_capacity : 0
}
