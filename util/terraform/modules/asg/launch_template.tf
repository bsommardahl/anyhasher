resource "aws_launch_template" "this" {
  name_prefix            = "anyhasher-${var.environment}-lt-${var.ver}-"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name       = "anyhasher-${var.environment}-backend"
      Version    = var.ver
      Deployment = "${var.environment}-${var.ver}"
    }
  }
}

