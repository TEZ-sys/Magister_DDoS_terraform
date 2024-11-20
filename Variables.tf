variable "region" {
  description = "AWS London-Region"
}

variable "ports" {
  description = "Allow ports"
}

variable "CIDR" {
  description = "CIDR for ingress and egress"
}

variable "ami" {
  description = "Amazon Machine Image ID for Ubuntu Server 22"
}

variable "inst_type" {
  description = "Size of VM"
}
variable "inst_type_attack" {}
variable "scale_in_period" {}

variable "scale_out_period" {}

variable "scale_in_threshold" {}

variable "scale_out_threshold" {}

variable "evaluation_periods" {}

variable "network_period" {}

variable "network_threshold" { 
}

variable "metric_name" {}

variable "comparison" {}

variable "name_space" {}

variable "defenders_vpc_cidr" {}
variable "defenders_public_subnet" {}
variable "defenders_private_subnet" {}

variable "defenders_sub_public_subnet" {}
