output "module_cloudfront_oai_iam_arn" {
  description = "The IAM ARN for the CloudFront Origin Access Identity"
  value       = var.create_resource["cdn"] ? aws_cloudfront_origin_access_identity.my_oai[0].iam_arn : null
}
output "module_cdn_domain_name" {
  value = var.create_resource["cdn"] ? aws_cloudfront_distribution.my_distribution[0].domain_name : null
}

output "module_cdn_hosted_zone_id" {
  value = var.create_resource["cdn"] ? aws_cloudfront_distribution.my_distribution[0].hosted_zone_id : null
}