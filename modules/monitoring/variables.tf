variable "scale_in_period" {
  description = "Scale in preiod"
  type        = string
}
variable "scale_out_period" {
  description = "Scale out period"
  type        = string
}

variable "scale_in_threshold" {
  description = "Scale in threshold"
  type        = string
}

variable "scale_out_threshold" {
  description = "Scale out threshold"
  type        = string
}

variable "evaluation_periods" {
  description = "Evaluation period"
  type        = string
}

variable "network_period" {
  description = "Network perido"
  type        = string
}

variable "network_threshold" {
  description = "Network threshold"
  type        = string
}

variable "metric_name" {
  description = "Sets metric name"
  type        = list(any)

}

variable "comparison" {
  description = "Comparison data"
  type        = string
}

variable "name_space" {
  description = "Name space"
  type        = string
}

variable "module_instance_id" {
  description = "Instance_id of defender instance"
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