# Outputs are values you can reference in other Terraform configurations
# They're like return values from a function

output "s3_bucket_name" {
  description = "Name of the shared S3 bucket"
  value       = module.s3_bucket.bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the shared S3 bucket"
  value       = module.s3_bucket.bucket_arn
}

output "hosted_zone_id" {
  description = "Route53 hosted zone ID"
  value       = module.dns.hosted_zone_id
}

output "name_servers" {
  description = "Name servers for domain configuration"
  value       = module.dns.name_servers
}

