# Demo Terraform Environment - Local Backend (no AWS required)
#
# This environment is purely for testing the CI/CD workflow.
# It uses a local backend and null resources so the pipeline
# (fmt / init / validate / plan) runs without any AWS credentials.

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }

  # Local backend - no S3 bucket needed
  backend "local" {
    path = "terraform.tfstate"
  }
}

# -----------------------------------------------------------------------
# Demo null resources to simulate the real infra shape
# -----------------------------------------------------------------------
resource "null_resource" "demo_vpc" {
  triggers = {
    environment = var.environment
    cidr        = var.vpc_cidr
  }

  provisioner "local-exec" {
    command = "echo 'Demo VPC created for environment: ${var.environment} with CIDR: ${var.vpc_cidr}'"
  }
}

resource "null_resource" "demo_subnets" {
  depends_on = [null_resource.demo_vpc]

  triggers = {
    public_subnets  = join(",", var.public_subnet_cidrs)
    private_subnets = join(",", var.private_subnet_cidrs)
  }

  provisioner "local-exec" {
    command = "echo 'Demo Subnets: public=${join(",", var.public_subnet_cidrs)} private=${join(",", var.private_subnet_cidrs)}'"
  }
}

resource "null_resource" "demo_alb" {
  depends_on = [null_resource.demo_subnets]

  triggers = {
    alb_name = "kong-alb-${var.environment}"
  }

  provisioner "local-exec" {
    command = "echo 'Demo ALB: kong-alb-${var.environment} created'"
  }
}
