resource "aws_route53_zone" "domain" {
  count   = var.create_resource["dns"] ? 1 : 0
  name    = var.domain_name
  comment = "Managed by terraform module: domain"
  vpc {
    vpc_id     = var.vpc_id
    vpc_region = var.vpc_region
  }
  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}


resource "aws_route53_record" "records" {
  count   = var.create_resource["dns"] ? 1 : 0
  zone_id = aws_route53_zone.domain[0].id
  name    = var.domain_name
  type    = var.dns_type
  ttl     = var.dns_ttl
  records = aws_route53_zone.domain[0].name_servers
}