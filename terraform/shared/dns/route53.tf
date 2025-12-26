# Route53 manages DNS for kuroshio-lab.com and all subdomains
# Each subdomain (species., dashboard., etc.) will be created here

resource "aws_route53_zone" "main" {
  name = var.domain_name

  tags = {
    Name        = "kuroshio-lab-main-zone"
    Description = "Main hosted zone for all Kuroshio-Lab applications"
  }
}

# Placeholder records for each application
# These will point to load balancers/CloudFront created in app-specific infra

locals {
  applications = [
    "species",
    "dashboard",
    "reef",
    "encyclopedia",
    "monitoring"
  ]
}

# Example: species.kuroshio-lab.com placeholder
# You'll update the actual targets when deploying each app
resource "aws_route53_record" "app_placeholders" {
  for_each = toset(local.applications)

  zone_id = aws_route53_zone.main.zone_id
  name    = "${each.value}.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = ["127.0.0.1"] # Placeholder - update when app is deployed

  lifecycle {
    ignore_changes = [records] # Prevents Terraform from overwriting app changes
  }
}

# API subdomains
resource "aws_route53_record" "api_placeholders" {
  for_each = toset(local.applications)

  zone_id = aws_route53_zone.main.zone_id
  name    = "api.${each.value}.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = ["127.0.0.1"]

  lifecycle {
    ignore_changes = [records]
  }
}
