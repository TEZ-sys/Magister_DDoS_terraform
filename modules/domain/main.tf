terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 5.34.0"
      configuration_aliases = [aws.ssl]
    }
  }
}

resource "aws_route53_zone" "domain" {

  count   = var.create_resource["dns"] ? 1 : 0
  name    = var.domain_name
  comment = "Managed by terraform module: domain"

  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}


resource "aws_route53_record" "records" {

  count           = var.create_resource["dns"] ? 1 : 0
  zone_id         = aws_route53_zone.domain[0].id
  allow_overwrite = true
  name            = var.domain_name
  type            = var.dns_type
  ttl             = var.dns_ttl
  records         = aws_route53_zone.domain[0].name_servers
}

resource "aws_route53domains_registered_domain" "this" {
  count       = var.create_resource["dns"] ? 1 : 0
  domain_name = var.domain_name

  dynamic "name_server" {
    for_each = aws_route53_zone.domain[0].name_servers
    content {
      name = name_server.value
    }
  }
}

resource "aws_route53_record" "cdn_alias" {
  count   = var.create_resource["dns"] ? 1 : 0
  zone_id = aws_route53_zone.domain[0].id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.cdn_domain_name
    zone_id                = var.cdn_hosted_zone_id
    evaluate_target_health = false
  }
}