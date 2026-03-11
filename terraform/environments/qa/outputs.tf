output "vpc_id" {
  description = "QA VPC ID"
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "QA ALB DNS Name"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "QA ALB Zone ID"
  value       = module.alb.alb_zone_id
}

output "bastion_public_ip" {
  description = "Public IP of QA bastion host"
  value       = aws_instance.bastion.public_ip
}
