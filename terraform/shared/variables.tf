# Variables allow you to customize your infrastructure without changing code
# Think of these as function parameters

variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "eu-west-3"
}

variable "domain_name" {
  description = "Root domain name"
  type        = string
  default     = "kuroshio-lab.com"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}
