# Lookup or create hosted zone (managed from Central)
data "aws_route53_zone" "main" {
  name         = var.zone_name
  private_zone = false
}

# qa.example.com -> QA Kong ALB
resource "aws_route53_record" "qa" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "qa.${var.zone_name}"
  type    = "A"

  alias {
    name                   = var.qa_alb_dns_name
    zone_id                = var.qa_alb_zone_id
    evaluate_target_health = true
  }
}

# prod.example.com -> Prod Kong ALB
resource "aws_route53_record" "prod" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "prod.${var.zone_name}"
  type    = "A"

  alias {
    name                   = var.prod_alb_dns_name
    zone_id                = var.prod_alb_zone_id
    evaluate_target_health = true
  }
}
