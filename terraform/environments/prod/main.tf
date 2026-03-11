provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "prod"
      Project     = "Kong-Infra"
      ManagedBy   = "Terraform"
    }
  }
}

# ---------------------------------------------------------------------------
# VPC
# ---------------------------------------------------------------------------
module "vpc" {
  source      = "../../modules/vpc"
  cidr_block  = var.vpc_cidr
  vpc_name    = "prod-vpc"
  environment = "prod"
}

# ---------------------------------------------------------------------------
# Subnets
# ---------------------------------------------------------------------------
module "subnets" {
  source               = "../../modules/subnets"
  vpc_id               = module.vpc.vpc_id
  environment          = "prod"
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

# ---------------------------------------------------------------------------
# Security Groups
# ---------------------------------------------------------------------------
module "security_groups" {
  source      = "../../modules/security-groups"
  vpc_id      = module.vpc.vpc_id
  environment = "prod"
}

# ---------------------------------------------------------------------------
# Route Tables
# ---------------------------------------------------------------------------
module "route_table" {
  source             = "../../modules/route-table"
  vpc_id             = module.vpc.vpc_id
  environment        = "prod"
  igw_id             = module.vpc.igw_id
  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
}

# ---------------------------------------------------------------------------
# Application Load Balancer (Kong ALB)
# ---------------------------------------------------------------------------
module "alb" {
  source                = "../../modules/alb"
  vpc_id                = module.vpc.vpc_id
  environment           = "prod"
  public_subnet_ids     = module.subnets.public_subnet_ids
  alb_security_group_id = module.security_groups.alb_sg_id
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
  name        = "prod-bastion-sg"
  description = "Allow SSH access to prod bastion"
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

  tags = {
    Name = "prod-bastion-sg"
  }
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro" # Free-tier eligible
  subnet_id                   = module.subnets.public_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  key_name                    = var.key_pair_name # Major.pem key pair
  associate_public_ip_address = true

  tags = {
    Name        = "prod-bastion"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}
