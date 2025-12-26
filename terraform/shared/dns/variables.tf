variable "domain_name" {
  description = "Root domain name"
  type        = string
}

variable "google_site_verification_token" {
  description = "Token for Google site verification"
  type        = string
  sensitive   = true
}

variable "resend_dkim_public_key" {
  description = "Resend DKIM public key for TXT record"
  type        = string
  sensitive   = true
}

variable "acm_validation_cname_name" {
  description = "CNAME name for ACM certificate validation"
  type        = string
  sensitive   = true
}

variable "acm_validation_cname_value" {
  description = "CNAME value for ACM certificate validation"
  type        = string
  sensitive   = true
}
