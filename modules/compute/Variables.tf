variable "create_resource" {
  description = "Map of resources to create"
  type        = map(bool)
}

variable "scale_out_capacity" {
  description = "Amount of instances for each of ASG"
  type        = map(number)
}

variable "region" {
  description = "AWS London-Region"
  type        = string
}

variable "ami" {
  description = "Amazon Machine Image ID for Ubuntu Server 22"
  type        = string
  default     = ""
}

variable "inst_type" {
  description = "Size of VM"
  type        = string
}

variable "public_subnet_id" {
  description = "CIDR for public subnet"
  type        = string
}

variable "sub_public_subnet" {
  description = "CIDR for public subnet"
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

variable "vpc_id" {
  description = "Vpc id for security group"
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