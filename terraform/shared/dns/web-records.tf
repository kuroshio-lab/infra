    resource "aws_route53_record" "root_a" {
      zone_id = aws_route53_zone.main.zone_id
      name    = "kuroshio-lab.com"
      type    = "A"

      alias {
        name                   = "d3u3q9ug4uc6sm.cloudfront.net"
        zone_id                = "Z2FDTNDATAQYW2"
        evaluate_target_health = false
      }
    }

    resource "aws_route53_record" "www" {
      zone_id = aws_route53_zone.main.zone_id
      name    = "www.kuroshio-lab.com"
      type    = "CNAME"
      ttl     = 500
      records = ["d3u3q9ug4uc6sm.cloudfront.net"]
    }
