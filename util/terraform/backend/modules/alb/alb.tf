resource "aws_lb" "this" {
  name               = "anyhasher-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "blue" {
  name                 = "anyhasher-${var.environment}-blue-tg"
  port                 = 5001
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "instance"
  deregistration_delay = 30

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 15
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "anyhasher-${var.environment}-blue"
    Type = "blue"
  }
}

resource "aws_lb_target_group" "green" {
  count = var.use_green_environment ? 1 : 0
  
  name                 = "anyhasher-${var.environment}-green-tg"
  port                 = 5001
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "instance"
  deregistration_delay = 30

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 15
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "anyhasher-${var.environment}-green"
    Type = "green"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.cert.arn #Assuming there is a data source for the certificate
  # certificate_arn   = aws_acm_certificate_validation.cert.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn  # Always forward to blue as it's always active
  }
}

# Rule to route traffic to green environment only when X-Environment header is "green" and green exists
resource "aws_lb_listener_rule" "route_to_green_environment" {
  count = var.use_green_environment ? 1 : 0
  
  listener_arn = aws_lb_listener.https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green[0].arn
  }

  condition {
    http_header {
      http_header_name = "X-Environment"
      values           = ["green"]
    }
  }
}
