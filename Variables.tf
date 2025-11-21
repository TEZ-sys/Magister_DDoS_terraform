variable "create_resource" {
  description = "True or false to create a resource"
  type        = map(bool)
  default = {
    instance     = true
    auto_scale   = false
    load_balance = false
    monitoring   = false
  }
}

variable "scaleout_capacity" {
  description = "Amount of instances for each of ASG"
  type        = map(number)
  default = {
    min     = 1
    max   = 3
    desired = 2
  }
}
variable "availability_zones" {
  description = "Availability zones"
  type        = map(string)
  default     = {
    az1 = "eu-west-2a"
    az2 = "eu-west-2b"
    az3 = "eu-west-2c"
    }
}


variable "region" {
  description = "AWS London-Region"
  type        = string
}

variable "ami" {
  description = "Amazon Machine Image ID for Ubuntu Server 22"
  type        = string
  default     = null
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

variable "standarts_vpc_cidr" {
  description = "CIDR for VPC"
  type        = string
}

variable "standarts_public_subnet" {
  description = "CIDR for public subnet"
  type        = string
}

variable "standarts_private_subnet" {
  description = "CIDR for private subnet"
  type        = string
}

variable "standarts_sub_public_subnet" {
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
