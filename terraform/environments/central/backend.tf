terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "my-terraform-state-central"
    key            = "central/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks-central"
    encrypt        = true
  }
}
