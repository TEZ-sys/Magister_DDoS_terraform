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

variable "subnet_id" {
  description = "CIDR for public subnet"
  type        = string
}