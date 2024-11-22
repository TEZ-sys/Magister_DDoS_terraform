variable "region" {
  description = "AWS London-Region"
  type        = string
}

variable "ami" {
  description = "Amazon Machine Image ID for Ubuntu Server 22"
  type= string
  default =  null
}

variable "inst_type" {
  description = "Size of VM"
  type        = string
}

variable "ports" {
  description = "Allow ports"
  type        = list(any)
}

variable "CIDR" {
  description = "CIDR for ingress and egress"
  type        = list(any)
}

variable "defenders_vpc_cidr" {
  description = "CIDR for VPC"
  type        = string
}

variable "defenders_public_subnet" {
  description = "CIDR for public subnet"
  type        = string
}

variable "defenders_private_subnet" {
  description = "CIDR for private subnet"
  type        = string
}

variable "defenders_sub_public_subnet" {
  description = "CIDR for sub public subnet"
  type        = string
}

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
