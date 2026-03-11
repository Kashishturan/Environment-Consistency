output "vpc_id" {
  description = "Prod VPC ID"
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "Prod ALB DNS Name"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "Prod ALB Zone ID"
  value       = module.alb.alb_zone_id
}

output "bastion_public_ip" {
  description = "Public IP of Prod bastion host"
  value       = aws_instance.bastion.public_ip
}
