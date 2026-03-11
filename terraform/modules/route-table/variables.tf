variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "igw_id" {
  description = "Internet Gateway ID"
  type        = string
}

variable "peering_connection_id" {
  description = "VPC peering connection ID (optional)"
  type        = string
  default     = ""
}

variable "peer_vpc_cidr" {
  description = "CIDR of the peer VPC for routing (optional)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
