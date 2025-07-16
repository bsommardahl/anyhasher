resource "aws_security_group" "ec2_sg" {
  name        = "anyhasher-${var.environment}-${var.deployment_type}-ec2-sg"
  description = "Security group for EC2 instances (${var.deployment_type}) - restrictive inbound, open outbound"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from ALB only"
    from_port       = 5001
    to_port         = 5001
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  ingress {
    description = "SSH connection"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound traffic for updates and npm"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name           = "anyhasher-${var.environment}-${var.deployment_type}-ec2-sg"
    Environment    = var.environment
    DeploymentType = var.deployment_type
  }
}

