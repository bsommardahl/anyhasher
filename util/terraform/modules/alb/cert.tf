resource "aws_acm_certificate" "cert" {
  domain_name         = "*.${var.domain_root}"
  validation_method   = "DNS"
}

# Deduplicate by record name
locals {
  unique_validations = distinct([
    for dvo in aws_acm_certificate.cert.domain_validation_options : {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  ])
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for record in local.unique_validations :
    record.name => record
  }

  zone_id = var.route53_zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.value]
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}