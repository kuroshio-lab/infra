# TXT record for Resend DKIM
resource "aws_route53_record" "resend_dkim" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "resend._domainkey.notifications.kuroshio-lab.com"
  type    = "TXT"
  ttl     = 300
  records = ["p=${var.resend_dkim_public_key}"]
}

# MX record for Resend's SPF via SES
resource "aws_route53_record" "resend_spf_mx" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "send.notifications.kuroshio-lab.com"
  type    = "MX"
  ttl     = 300
  records = ["10 feedback-smtp.eu-west-1.amazonses.com"]
}

# TXT record for Resend's SPF via SES
resource "aws_route53_record" "resend_spf_txt" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "send.notifications.kuroshio-lab.com"
  type    = "TXT"
  ttl     = 300
  records = ["v=spf1 include:amazonses.com ~all"]
}
