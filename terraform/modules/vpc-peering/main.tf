# Peering request from Central VPC to QA/Prod VPC
resource "aws_vpc_peering_connection" "this" {
  vpc_id        = var.requestor_vpc_id
  peer_vpc_id   = var.acceptor_vpc_id
  peer_owner_id = var.acceptor_account_id
  peer_region   = var.acceptor_vpc_region
  auto_accept   = false

  tags = merge(
    {
      Name        = var.peering_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = "Kong-Infra"
    },
    var.tags
  )
}

# Acceptor side - run with the acceptor account's provider alias
resource "aws_vpc_peering_connection_accepter" "this" {
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
  auto_accept               = true

  tags = merge(
    {
      Name        = "${var.peering_name}-accepter"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = "Kong-Infra"
    },
    var.tags
  )
}
