output "module_route53_zone_id" {
  description = "The Route53 Hosted Zone ID for the domain"
  value       = var.create_resource["dns"] ? aws_route53_zone.domain[0].zone_id : null
}