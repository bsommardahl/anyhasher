resource "aws_launch_template" "this" {
  name_prefix            = "anyhasher-${var.environment}-${var.deployment_type}-lt-${var.ver}-"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  # IAM instance profile for S3 access
  iam_instance_profile {
    name = var.instance_profile_name
  }

  # User data script for automatic application deployment
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    version         = var.ver
    s3_bucket       = var.s3_bucket
    environment     = var.environment
    deployment_type = var.deployment_type
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name           = "anyhasher-${var.environment}-${substr(var.ver, -6, -1)}"
      Version        = var.ver
      Deployment     = "${var.environment}-${var.deployment_type}-${var.ver}"
      DeploymentType = var.deployment_type
    }
  }
}

