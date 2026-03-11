output "qa_dns_record" {
  description = "FQDN of the QA DNS record"
  value       = aws_route53_record.qa.fqdn
}

output "prod_dns_record" {
  description = "FQDN of the Prod DNS record"
  value       = aws_route53_record.prod.fqdn
}
