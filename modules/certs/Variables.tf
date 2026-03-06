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
variable "domain_name" {
  description = "Domain name for the certificate"
  type        = string
}
variable "zone_id" {
  description = "Route53 Hosted Zone ID"
  type        = string
}