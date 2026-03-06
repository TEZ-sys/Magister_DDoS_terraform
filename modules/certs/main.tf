terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.49.0"
      # This tells the module to look for an external provider named "aws.ssl"
      configuration_aliases = [ aws.ssl ]
    }
  }
}

# 1. The Certificate
resource "aws_acm_certificate" "cdn_cert" {
  provider          = aws.ssl
  count             = var.create_resource["cdn"] ? 1 : 0
  domain_name       = var.domain_name
  validation_method = "DNS"
}

# 2. The Validation Record (CRITICAL: Ensure zone_id is the PUBLIC one)
resource "aws_route53_record" "cert_validation" {
  provider = aws.ssl
  for_each = var.create_resource["cdn"] ? {
    for dvo in aws_acm_certificate.cdn_cert[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.zone_id
}

# 3. The Validation Waiter
resource "aws_acm_certificate_validation" "cdn_cert" {
  provider                = aws.ssl
  count                   = var.create_resource["cdn"] ? 1 : 0
  certificate_arn         = aws_acm_certificate.cdn_cert[0].arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}