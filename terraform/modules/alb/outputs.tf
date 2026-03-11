output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.kong.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.kong.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the ALB (for Route53 alias records)"
  value       = aws_lb.kong.zone_id
}
