# This file configures where Terraform stores its state
# State = the current state of your infrastructure
# IMPORTANT: Run this AFTER creating the S3 bucket manually first time

terraform {
  backend "s3" {
    bucket = "kuroshio-lab-terraform-state"
    key    = "shared/terraform.tfstate"
    region = "eu-west-3"  # Change to your preferred region

    # Prevents simultaneous modifications
    dynamodb_table = "terraform-state-lock"

    # Encryption at rest
    encrypt = true
  }
}
