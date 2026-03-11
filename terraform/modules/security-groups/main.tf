# ALB Security Group - allows HTTP/HTTPS from internet
resource "aws_security_group" "alb" {
  name        = "${var.environment}-alb-sg"
  description = "Security group for Kong ALB - allows HTTP/HTTPS"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.alb_ingress_cidr
  }

  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.alb_ingress_cidr
  }

  # Allow traffic from peered VPCs (e.g., Central)
  dynamic "ingress" {
    for_each = length(var.peering_cidr_blocks) > 0 ? [1] : []
    content {
      description = "Traffic from peered VPCs"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = var.peering_cidr_blocks
    }
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name        = "${var.environment}-alb-sg"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = "Kong-Infra"
    },
    var.tags
  )
}
