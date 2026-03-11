resource "aws_lb" "kong" {
  name               = "kong-alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  tags = merge(
    {
      Name        = "kong-alb-${var.environment}"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = "Kong-Infra"
    },
    var.tags
  )
}

# Default HTTP listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.kong.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Kong ALB - ${var.environment}"
      status_code  = "200"
    }
  }
}
