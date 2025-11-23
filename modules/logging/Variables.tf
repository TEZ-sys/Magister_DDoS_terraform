variable "create_resource" {
  description = "Map of resources to create"
  type        = map(bool)
}

variable "sns_topic_arn" {
  description = "SNS topic ARN"
  type        = string
}

variable "resource_owner" {
  description = "Owner of resources"
  type        = map(string)
}

variable "retention_days" {
  description = "Retention days for log group"
  type        = number
}