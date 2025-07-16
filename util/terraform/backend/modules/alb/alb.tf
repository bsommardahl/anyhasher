resource "aws_lb" "this" {
  name               = "anyhasher-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnet_ids
}

# Production target group
resource "aws_lb_target_group" "production" {
  name        = "anyhasher-${var.environment}-prod-tg"
  port        = 5001
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

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
    Name = "anyhasher-${var.environment}-production"
    Type = "production"
  }
}

# Canary target group
resource "aws_lb_target_group" "canary" {
  count = var.canary_enabled ? 1 : 0
  
  name        = "anyhasher-${var.environment}-canary-tg"
  port        = 5001
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

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
    Name = "anyhasher-${var.environment}-canary"
    Type = "canary"
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

  # When canary is enabled, use weighted routing, otherwise just production
  default_action {
    type = "forward"
    
    dynamic "forward" {
      for_each = var.canary_enabled ? [1] : []
      content {
        target_group {
          arn    = aws_lb_target_group.production.arn
          weight = 100 - var.canary_traffic_percentage
        }
        target_group {
          arn    = aws_lb_target_group.canary[0].arn
          weight = var.canary_traffic_percentage
        }
      }
    }

    target_group_arn = var.canary_enabled ? null : aws_lb_target_group.production.arn
  }
}
