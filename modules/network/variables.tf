variable "create_resource" {
  description = "Map of resources to create"
  type        = map(bool)
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

variable "subnet_id" {
  description = "CIDR for public subnet"
  type        = string
}