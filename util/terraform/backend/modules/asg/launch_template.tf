resource "aws_launch_template" "this" {
  name_prefix            = "anyhasher-${var.environment}-${var.deployment_color}-lt-${var.ver}"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  iam_instance_profile {
    name = var.instance_profile_name
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    version          = var.ver
    s3_bucket        = var.s3_bucket
    environment      = var.environment
    deployment_color = var.deployment_color
  }))

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name            = "anyhasher-${var.environment}-${var.deployment_color}-lt-${var.ver}"
      Version         = var.ver
      Deployment      = "${var.environment}-${var.deployment_color}-${var.ver}"
      DeploymentColor = var.deployment_color
    }
  }
}

