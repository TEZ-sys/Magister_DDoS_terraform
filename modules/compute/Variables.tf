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
