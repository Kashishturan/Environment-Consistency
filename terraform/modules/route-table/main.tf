# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  # Optional: Route to peered VPC
  dynamic "route" {
    for_each = var.peering_connection_id != "" ? [1] : []
    content {
      cidr_block                = var.peer_vpc_cidr
      vpc_peering_connection_id = var.peering_connection_id
    }
  }

  tags = merge(
    {
      Name        = "${var.environment}-public-rt"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = "Kong-Infra"
    },
    var.tags
  )
}

# Associate public subnets with the public route table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_ids)
  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  # Optional: Route to peered VPC
  dynamic "route" {
    for_each = var.peering_connection_id != "" ? [1] : []
    content {
      cidr_block                = var.peer_vpc_cidr
      vpc_peering_connection_id = var.peering_connection_id
    }
  }

  tags = merge(
    {
      Name        = "${var.environment}-private-rt"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = "Kong-Infra"
    },
    var.tags
  )
}

# Associate private subnets with private route table
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_ids)
  subnet_id      = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private.id
}
