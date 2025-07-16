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

data "aws_autoscaling_group" "production_current" {
  count = length(data.aws_autoscaling_groups.production_existing.names) > 0 ? 1 : 0
  name  = "anyhasher-${var.environment}-production"
}

data "aws_instances" "production_current" {
  count = length(data.aws_autoscaling_groups.production_existing.names) > 0 ? 1 : 0
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

data "aws_instance" "production_first" {
  count       = length(data.aws_autoscaling_groups.production_existing.names) > 0 && length(data.aws_instances.production_current[0].ids) > 0 ? 1 : 0
  instance_id = data.aws_instances.production_current[0].ids[0]
}

locals {
  production_asg_exists = contains(data.aws_autoscaling_groups.production_existing.names, "anyhasher-${var.environment}-production")
  current_production_version = local.production_asg_exists && length(data.aws_instance.production_first) > 0 ? lookup(data.aws_instance.production_first[0].tags, "Version", var.ver) : var.ver
}
