output "bucket_name" {
  value = aws_s3_bucket.shared_assets.id
}

output "bucket_arn" {
  value = aws_s3_bucket.shared_assets.arn
}
