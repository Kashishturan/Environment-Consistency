resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    {
      Name        = var.vpc_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = "Kong-Infra"
    },
    var.tags
  )
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name        = "${var.vpc_name}-igw"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = "Kong-Infra"
    },
    var.tags
  )
}
