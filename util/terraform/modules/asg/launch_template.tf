resource "aws_launch_template" "this" {
  name_prefix   = "${var.environment}-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  #user_data = base64encode(file("${path.module}/../../../user_data.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.environment}-node"
    }
  }
}