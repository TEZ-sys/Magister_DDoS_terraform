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
variable "region" {
  description = "AWS London-Region"
  type        = string
}
variable "secrets_arn" {
  description = "ARN of the secret in AWS Secrets Manager"
  type        = string
}