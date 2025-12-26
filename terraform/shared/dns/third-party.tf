# CNAME for ACM validation (if applicable - ensure this is still needed)
resource "aws_route53_record" "acm_validation" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.acm_validation_cname_name
  type    = "CNAME"
  ttl     = 500
  records = [var.acm_validation_cname_value]
}
