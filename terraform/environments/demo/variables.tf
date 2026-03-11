variable "environment" {
  description = "Environment name"
  type        = string
  default     = "demo"
}

variable "vpc_cidr" {
  description = "VPC CIDR block (used in output messages)"
  type        = string
  default     = "10.99.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default     = ["10.99.1.0/24", "10.99.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  type        = list(string)
  default     = ["10.99.3.0/24", "10.99.4.0/24"]
}
