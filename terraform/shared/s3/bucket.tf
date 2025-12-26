# S3 bucket for all application assets
# Uses prefix-based isolation: species/, dashboard/, reef/, etc.

resource "aws_s3_bucket" "shared_assets" {
  bucket = "kuroshio-lab-assets"

  tags = {
    Name        = "kuroshio-lab-assets"
    Description = "Shared storage for all Kuroshio-Lab applications"
  }
}

# Enable versioning (keeps old versions of files)
resource "aws_s3_bucket_versioning" "shared_assets" {
  bucket = aws_s3_bucket.shared_assets.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable encryption at rest
resource "aws_s3_bucket_server_side_encryption_configuration" "shared_assets" {
  bucket = aws_s3_bucket.shared_assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access by default (apps use IAM roles)
resource "aws_s3_bucket_public_access_block" "shared_assets" {
  bucket = aws_s3_bucket.shared_assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Lifecycle rules to save costs
resource "aws_s3_bucket_lifecycle_configuration" "shared_assets" {
  bucket = aws_s3_bucket.shared_assets.id

  # Move old files to cheaper storage after 90 days
  rule {
    id     = "archive-old-data"
    status = "Enabled"

    filter {}

    transition {
      days          = 90
      storage_class = "STANDARD_IA" # Infrequent Access
    }

    transition {
      days          = 180
      storage_class = "GLACIER_IR" # Glacier Instant Retrieval
    }
  }
}
