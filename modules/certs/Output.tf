output "cdn_certificate_arn" {
  description = "The ACM Certificate ARN for the CDN"
  value       = var.create_resource["cdn"] ? aws_acm_certificate.cdn_cert[0].arn : null
}