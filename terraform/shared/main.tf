# Main Terraform configuration for shared Kuroshio-Lab infrastructure
# This file defines the AWS provider and basic settings

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  # Default tags applied to ALL resources
  default_tags {
    tags = {
      Project     = "Kuroshio-Lab"
      ManagedBy   = "Terraform"
      Environment = "production"
    }
  }
}
