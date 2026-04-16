variable "create_resource" {
  description = "Map of resources to create"
  type        = map(bool)
}
variable "scale_in_period" {
  description = "Scale in preiod"
  type        = number
}
variable "scale_out_period" {
  description = "Scale out period"
  type        = number
}

variable "sns_alert_topic_arn" {
  description = "SNS arn topic ARN"
  type        = string
}

variable "sns_ok_topic_arn" {
  description = "SNS ok topic ARN"
  type        = string
}

variable "resource_owner" {
  description = "Owner of resources"
  type        = map(string)
}

variable "scale_in_threshold" {
  description = "Scale in threshold"
  type        = number
}

variable "scale_out_threshold" {
  description = "Scale out threshold"
  type        = number
}

variable "evaluation_periods" {
  description = "Evaluation period"
  type        = string
}

variable "network_period" {
  description = "Network perido"
  type        = number
}

variable "network_threshold" {
  description = "Network threshold"
  type        = number
}

variable "metric_name" {
  description = "Sets metric name"
  type        = map(string)

}

variable "comparison" {
  description = "Comparison data"
  type        = string
}

variable "name_space" {
  description = "Name space"
  type        = map(string)
}

variable "module_instance_id" {
  description = "Instance_id of standart instance"
  type        = string
}
variable "module_sub_instance_id" {
  description = "Instance_id of sub instance"
  type        = string
}

variable "module_scale_out_id" {
  description = "Scale out id"
  type        = string
}
variable "module_scale_in_id" {
  description = "Scale in id"
  type        = string
}
variable "environment" {
  description = "Production or Stage environment"
  type        = string
}
variable "database_period" {
  description = "Database period"
  type        = number
}