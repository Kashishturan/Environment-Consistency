provider "aws" {
  region = var.aws_region
  alias  = "central"

  default_tags {
    tags = {
      Environment = "central"
      Project     = "Kong-Infra"
      ManagedBy   = "Terraform"
    }
  }
}

# ---------------------------------------------------------------------------
# Central VPC
# ---------------------------------------------------------------------------
module "vpc" {
  source      = "../../modules/vpc"
  cidr_block  = var.vpc_cidr
  vpc_name    = "central-vpc"
  environment = "central"
}

# ---------------------------------------------------------------------------
# Subnets
# ---------------------------------------------------------------------------
module "subnets" {
  source               = "../../modules/subnets"
  vpc_id               = module.vpc.vpc_id
  environment          = "central"
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

# ---------------------------------------------------------------------------
# Route Tables
# ---------------------------------------------------------------------------
module "route_table" {
  source             = "../../modules/route-table"
  vpc_id             = module.vpc.vpc_id
  environment        = "central"
  igw_id             = module.vpc.igw_id
  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
}

# ---------------------------------------------------------------------------
# VPC Peering: Central <-> QA
# ---------------------------------------------------------------------------
module "peering_central_qa" {
  source              = "../../modules/vpc-peering"
  requestor_vpc_id    = module.vpc.vpc_id
  acceptor_vpc_id     = var.qa_vpc_id
  acceptor_account_id = var.qa_account_id
  acceptor_vpc_region = var.aws_region
  environment         = "central"
  peering_name        = "central-to-qa"
}

# ---------------------------------------------------------------------------
# VPC Peering: Central <-> Prod
# ---------------------------------------------------------------------------
module "peering_central_prod" {
  source              = "../../modules/vpc-peering"
  requestor_vpc_id    = module.vpc.vpc_id
  acceptor_vpc_id     = var.prod_vpc_id
  acceptor_account_id = var.prod_account_id
  acceptor_vpc_region = var.aws_region
  environment         = "central"
  peering_name        = "central-to-prod"
}

# ---------------------------------------------------------------------------
# Route53 DNS Records (managed from Central)
# ---------------------------------------------------------------------------
module "route53" {
  source            = "../../modules/route53"
  zone_name         = var.zone_name
  qa_alb_dns_name   = var.qa_alb_dns_name
  qa_alb_zone_id    = var.qa_alb_zone_id
  prod_alb_dns_name = var.prod_alb_dns_name
  prod_alb_zone_id  = var.prod_alb_zone_id
}

# ---------------------------------------------------------------------------
# EC2 Ubuntu Free-Tier Bastion (t2.micro, Ubuntu 22.04 LTS)
# ---------------------------------------------------------------------------
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "bastion" {
  name        = "central-bastion-sg"
  description = "Allow SSH to central bastion"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "central-bastion-sg" }
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro" # Free-tier eligible
  subnet_id                   = module.subnets.public_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  key_name                    = var.key_pair_name # Major.pem
  associate_public_ip_address = true

  tags = {
    Name        = "central-bastion"
    Environment = "central"
    ManagedBy   = "Terraform"
  }
}
