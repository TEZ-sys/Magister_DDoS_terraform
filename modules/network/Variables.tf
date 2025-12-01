variable "create_resource" {
  description = "Map of resources to create"
  type        = map(bool)
}
variable "availability_zones" {
  description = "Availability zones"
  type        = map(string)
}
variable "resource_owner" {
  description = "Owner of resources"
  type        = map(string)
}

variable "region" {
  description = "AWS London-Region"
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

variable "vpc_cidr" {
  description = "CIDR for VPC"
  type        = string
}

variable "public_subnet" {
  description = "CIDR for public subnet"
  type        = string
}

variable "private_subnet" {
  description = "CIDR for private subnet"
  type        = string
}

variable "sub_public_subnet" {
  description = "CIDR for sub public subnet"
  type        = string
}

variable "subnet_id" {
  description = "CIDR for public subnet"
  type        = string
}
variable "environment" {
  description = "Production or Stage environment"
  type        = string
}