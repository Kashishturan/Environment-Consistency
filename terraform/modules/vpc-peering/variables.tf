variable "requestor_vpc_id" {
  description = "VPC ID of the peering requestor (Central VPC)"
  type        = string
}

variable "acceptor_vpc_id" {
  description = "VPC ID of the peering acceptor (QA or Prod VPC)"
  type        = string
}

variable "acceptor_account_id" {
  description = "AWS Account ID of the acceptor"
  type        = string
}

variable "acceptor_vpc_region" {
  description = "AWS Region of the acceptor VPC"
  type        = string
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
}

variable "peering_name" {
  description = "Name for the peering connection"
  type        = string
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
