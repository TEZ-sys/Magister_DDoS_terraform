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

variable "cdn_ttl" {
  description = "CDN TTL"
  type        = map(number)
}

variable "cdn_allowed_methods" {
  description = "CDN allowed methods"
  type        = list(string)
}

variable "cdn_cached_methods" {
  description = "CDN cached methods"
  type        = list(string)
}
variable "cdn_boolean" {
  description = "Owner of resources"
  type        = map(bool)
}

variable "cdn_string_config" {
  description = "CDN string config"
  type        = map(string)
}

variable "cdn_viewer_protocol_policy" {
  description = "CDN viewer protocol policy"
  type        = string
}
variable "cdn_s3_origin" {
  description = "CDN S3 origin ID"
  type        = string
}
variable "cdn_certificate_arn" {
  description = "CDN ACM Certificate ARN"
  type        = string

}
variable "bucket_name" {
  description = "S3 Bucket name"
  type        = string
}

variable "cdn_s3_link" {
  description = "S3 Bucket link for CDN"
  type        = string
}
variable "index_document" {
  description = "S3 Object key"
  type        = string
}
