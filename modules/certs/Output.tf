output "cdn_certificate_arn" {
  description = "The ACM Certificate ARN for the CDN"
  value = one(aws_acm_certificate.cdn_cert[*].arn)
}