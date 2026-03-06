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

resource "aws_route53_zone" "domain" {
  provider          = aws.ssl
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
  provider          = aws.ssl
  count   = var.create_resource["dns"] ? 1 : 0
  zone_id = aws_route53_zone.domain[0].id
  name    = var.domain_name
  type    = var.dns_type
  ttl     = var.dns_ttl
  records = aws_route53_zone.domain[0].name_servers
}