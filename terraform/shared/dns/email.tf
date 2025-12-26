# MX records for OVH mail
resource "aws_route53_record" "kuroshio_lab_mx" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "kuroshio-lab.com"
  type    = "MX"
  ttl     = 300
  records = [
    "50 mx2.mail.ovh.net.",
    "5 mx1.mail.ovh.net.",
    "100 mx3.mail.ovh.net.",
    "1 mx0.mail.ovh.net.",
  ]
}

# TXT record for SPF and Google Site Verification
resource "aws_route53_record" "kuroshio_lab_txt" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "kuroshio-lab.com"
  type    = "TXT"
  ttl     = 300
  records = [
    "v=spf1 include:mx.ovh.com ~all",
    "google-site-verification=${var.google_site_verification_token}"
    ]
  }

# CNAME records for OVH DKIM
resource "aws_route53_record" "ovh_dkim_selector_1" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "ovhmo-selector-1._domainkey.kuroshio-lab.com"
  type    = "CNAME"
  ttl     = 1800
  records = ["ovhmo-selector-1._domainkey.4344228.qc.dkim.mail.ovh.net."]
}

resource "aws_route53_record" "ovh_dkim_selector_2" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "ovhmo-selector-2._domainkey.kuroshio-lab.com"
  type    = "CNAME"
  ttl     = 1800
  records = ["ovhmo-selector-2._domainkey.4344229.qc.dkim.mail.ovh.net."]
}

# SRV record for Autodiscover (OVH)
resource "aws_route53_record" "autodiscover_srv" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "_autodiscover._tcp.kuroshio-lab.com"
  type    = "SRV"
  ttl     = 300
  records = ["0 0 443 zimbra1.mail.ovh.net."]
}
