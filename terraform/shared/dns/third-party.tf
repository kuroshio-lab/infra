# CNAME for ACM validation (if applicable - ensure this is still needed)
resource "aws_route53_record" "acm_validation" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "_b1056cf9fd04fbe3d175261fae886b9a.kuroshio-lab.com"
  type    = "CNAME"
  ttl     = 500
  records = [var.acm_validation_cname_value]
}
