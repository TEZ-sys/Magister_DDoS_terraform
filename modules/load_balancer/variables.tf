variable "region" {
  description = "AWS London-Region"
  type        = string
}

variable "ports" {
  description = "Allow ports"
  type        = list(any)
}

variable "vpc_id" {
  description = "Vpc id for security group"
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

variable "module_instance_id" {
  description = "Instance_id of defender instance"
  type        = string
}

variable "module_alb_security_group" {
  description = "Security Group for ALB"
  type        = string
}