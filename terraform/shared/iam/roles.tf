# IAM roles for each application
# Each app gets its own role with access ONLY to its S3 prefix

locals {
  applications = [
    "species",
    "dashboard",
    "reef",
    "encyclopedia",
    "monitoring"
  ]
}

# Base IAM role for each application
resource "aws_iam_role" "app_role" {
  for_each = toset(local.applications)
  
  name = "kuroshio-lab-${each.value}-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "ecs-tasks.amazonaws.com",
            "lambda.amazonaws.com"
          ]
        }
      }
    ]
  })
  
  tags = {
    Application = each.value
  }
}

# S3 access policy for each app (scoped to their prefix)
resource "aws_iam_role_policy" "app_s3_access" {
  for_each = toset(local.applications)
  
  name = "s3-access"
  role = aws_iam_role.app_role[each.key].id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "${aws_s3_bucket.shared_assets.arn}/${each.value}/*",
          "${aws_s3_bucket.shared_assets.arn}"
        ]
        Condition = {
          StringLike = {
            "s3:prefix" = ["${each.value}/*"]
          }
        }
      }
    ]
  })
}

# CloudWatch Logs access (for application logging)
resource "aws_iam_role_policy_attachment" "app_cloudwatch" {
  for_each = toset(local.applications)
  
  role       = aws_iam_role.app_role[each.key].name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}
