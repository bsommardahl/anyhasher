resource "aws_security_group" "ec2_sg" {
  name        = "anyhasher-${var.environment}-ec2-sg"
  description = "Security group for EC2 instances - restrictive inbound, open outbound"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from ALB only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    description = "All outbound traffic for updates and npm"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "anyhasher-${var.environment}-ec2-sg"
  }
}

