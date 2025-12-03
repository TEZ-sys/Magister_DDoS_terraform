output "module_s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = var.create_resource["s3_storage"] ? aws_s3_bucket.nebo_bucket[0].bucket : null
}

output "module_s3_bucket_website_endpoint" {
  description = "Website endpoint for the S3 bucket"
  value       = var.create_resource["s3_storage"] ? aws_s3_bucket_website_configuration.nebo_bucket_website[0].website_endpoint : null
}