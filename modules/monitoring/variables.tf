variable "scale_in_period" {
  default = 120
}
variable "scale_out_period" {
  default = 60
}

variable "scale_in_threshold" {
    default = 10
}

variable "scale_out_threshold" {
    default = 20
}

variable "evaluation_periods" {
  default = 2
}

variable "network_period" {
  default = 300
}

variable "network_threshold" {
  default = 2000000
  
}

variable "metric_name" {
  description = "Sets metric name"
  type        = list(any)
  default = ["CPUUtilization","NetworkIn","NetworkOut"]
}

variable "comparison" {
  default="GreaterThanOrEqualToThreshold"
}

variable "name_space" {
  default = "AWS/EC2"
}