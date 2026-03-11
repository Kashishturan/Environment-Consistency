variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the Central VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "zone_name" {
  description = "Route53 hosted zone name"
  type        = string
}

variable "qa_alb_dns_name" {
  description = "DNS name of the QA ALB (via SSM or remote state)"
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

variable "qa_vpc_id" {
  description = "VPC ID of the QA account"
  type        = string
}

variable "qa_account_id" {
  description = "AWS Account ID for QA"
  type        = string
}

variable "prod_vpc_id" {
  description = "VPC ID of the Prod account"
  type        = string
}

variable "prod_account_id" {
  description = "AWS Account ID for Prod"
  type        = string
}

variable "key_pair_name" {
  description = "Name of the EC2 key pair"
  type        = string
  default     = "Major"
}
