variable "domain_name" {
  description = "The domain name (example.com)"
  type        = string
}

variable "dns_type" {
  description = "DNS record type (A, CNAME, etc.)"
  type        = string
}

variable "dns_ttl" {
  description = "DNS record TTL"
  type        = number
}

variable "zone_type" {
  description = "Type of Route53 zone: public or private"
  type        = string
  default     = "public"
}

variable "vpc_id" {
  description = "VPC id for private hosted zones (leave empty for public zones)"
  type        = string
}

variable "vpc_region" {
  description = "VPC region for private hosted zones (optional)"
  type        = string

}

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

variable "cdn_domain_name" {
  description = "CloudFront distribution domain name"
  type        = string
}

variable "cdn_hosted_zone_id" {
  description = "CloudFront hosted zone ID"
  type        = string
}