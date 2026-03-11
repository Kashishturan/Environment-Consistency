variable "zone_name" {
  description = "Route53 hosted zone name (e.g., example.com)"
  type        = string
}

variable "qa_alb_dns_name" {
  description = "DNS name of the QA ALB"
  type        = string
}

variable "qa_alb_zone_id" {
  description = "Zone ID of the QA ALB"
  type        = string
}

variable "prod_alb_dns_name" {
  description = "DNS name of the Prod ALB"
  type        = string
}

variable "prod_alb_zone_id" {
  description = "Zone ID of the Prod ALB"
  type        = string
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
