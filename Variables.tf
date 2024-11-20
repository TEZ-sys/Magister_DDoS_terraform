variable "region" {
  description = "AWS London-Region"
  default     = ["eu-west-2"]
}

variable "ami" {
  description = "Amazon Machine Image ID for Ubuntu Server 22"
  default     = ""
}

variable "inst_type" {
  description = "Size of VM"
  default     = "t2.nano"
}
variable "inst_type_attack" {
  description = "Size of VM"
  default     = "t2.micro"
}
variable "ports" {
  description = "Allow ports"
  type        = list(any)
  default     = ["22", "80", "443"]
}

variable "CIDR" {
  description = "CIDR for ingress and egress"
  default     = ["0.0.0.0/0"]
}

variable "defenders_vpc_cidr" {}
variable "defenders_public_subnet" {}
variable "defenders_private_subnet" {}

variable "defenders_sub_public_subnet" {}
