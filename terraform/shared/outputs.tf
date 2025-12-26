# Outputs are values you can reference in other Terraform configurations
# They're like return values from a function

output "s3_bucket_name" {
  description = "Name of the shared S3 bucket"
  value       = aws_s3_bucket.shared_assets.id
}

output "s3_bucket_arn" {
  description = "ARN of the shared S3 bucket"
  value       = aws_s3_bucket.shared_assets.arn
}

output "hosted_zone_id" {
  description = "Route53 hosted zone ID"
  value       = aws_route53_zone.main.zone_id
}

output "name_servers" {
  description = "Name servers for domain configuration"
  value       = aws_route53_zone.main.name_servers
}
