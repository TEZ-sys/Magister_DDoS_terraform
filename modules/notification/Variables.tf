variable "create_resource" {
  description = "Map of resources to create"
  type        = map(bool)
}

variable "resource_owner" {
  description = "Owner of resources"
  type        = map(string)
}

variable "email_address" {
  description = "Email address for sns"
  type        = string
}