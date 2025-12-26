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

variable "google_site_verification_token_for_dns" {
  description = "Token for Google site verification to be passed to DNS module"
  type        = string
  sensitive   = true
}

variable "resend_dkim_public_key_for_dns" {
  description = "Resend DKIM public key for TXT record to be passed to DNS module"
  type        = string
  sensitive   = true
}

variable "acm_validation_cname_name_for_dns" {
  description = "CNAME name for ACM certificate validation to be passed to DNS module"
  type        = string
  sensitive   = true
}

variable "acm_validation_cname_value_for_dns" {
  description = "CNAME value for ACM certificate validation to be passed to DNS module"
  type        = string
  sensitive   = true
}
