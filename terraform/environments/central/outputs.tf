output "vpc_id" {
  description = "Central VPC ID"
  value       = module.vpc.vpc_id
}

output "bastion_public_ip" {
  description = "Public IP of Central bastion host"
  value       = aws_instance.bastion.public_ip
}

output "qa_peering_connection_id" {
  description = "Central-QA VPC Peering Connection ID"
  value       = module.peering_central_qa.peering_connection_id
}

output "prod_peering_connection_id" {
  description = "Central-Prod VPC Peering Connection ID"
  value       = module.peering_central_prod.peering_connection_id
}
