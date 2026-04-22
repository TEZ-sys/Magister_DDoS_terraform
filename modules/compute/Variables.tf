variable "create_resource" {
  description = "Map of resources to create"
  type        = map(bool)
}

variable "scale_out_capacity" {
  description = "Amount of instances for each of ASG"
  type        = map(number)
}
variable "resource_owner" {
  description = "Owner of resources"
  type        = map(string)
}

variable "environment" {
  description = "Production or Stage environment"
  type        = string
}
variable "monitoring_profile" {
  description = "Monitoring profile"
  type        = string
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

variable "key_name" {
  description = "Key name for EC2 instances"
  type        = string
}
variable "custom_instance_profile" {
  description = "Instance profile name for the custom EC2 (DB) instance"
  type        = string
  default     = null
}