variable "create_resource" {
  description = "True or false to create a resource"
  type        = map(bool)
  default = {
    instance     = false
    auto_scale   = false
    load_balance = false
    monitoring   = false
    network      = false
    iam_role     = false
    sns_topic    = false
    logging      = false
  }
}

variable "scaleout_capacity" {
  description = "Amount of instances for each of ASG"
  type        = map(number)
  default = {
    min     = 1
    max     = 3
    desired = 2
  }
}
variable "availability_zones" {
  description = "Availability zones"
  type        = map(string)
  default = {
    az1 = "eu-west-2a"
    az2 = "eu-west-2b"
    az3 = "eu-west-2c"
  }
}

variable "resource_owner" {
  description = "Owner of resources"
  type        = map(string)
  default = {
    name  = "dfutumai"
    owner = "dfutumai"
  }
}
variable "environment" {
  description = "Production or Stage environment"
  type        = string
}
variable "retention_days" {
  description = "Retention days for log group"
  type        = number
  default     = 1
}

variable "profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "Terraform-AWS"
}
variable "key_name" {
  description = "Key name for EC2 instances"
  type        = string
  default     = "DevOps-IaC"
}
variable "email_address" {
  description = "Email address for sns"
  type        = string
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

variable "standart_vpc_cidr" {
  description = "CIDR for VPC"
  type        = string
}

variable "standart_public_subnet" {
  description = "CIDR for public subnet"
  type        = string
}

variable "standart_private_subnet" {
  description = "CIDR for private subnet"
  type        = string
}

variable "standart_sub_public_subnet" {
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

data "aws_availability_zones" "all" {}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}
