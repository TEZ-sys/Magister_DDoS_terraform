variable "create_resource" {
  description = "Map of resources to create"
  type        = map(bool)
}

variable "resource_owner" {
  description = "Owner of resources"
  type        = map(string)
}
variable "environment" {
  description = "Production or Stage environment"
  type        = string
}

variable "bucket_name" {
  description = "S3 Bucket name"
  type        = string
}

variable "bucket_acl" {
  description = "S3 Bucket acl"
  type        = string
}
variable "index_document" {
  description = "S3 Object key"
  type        = string
}
variable "error_document" {
  description = "S3 Object key"
  type        = string
}
variable "content_type" {
  description = "S3 Object content type"
  type        = string
}
variable "cloudfront_oai" {
  description = "CloudFront Origin Access Identity"
  type        = string
}