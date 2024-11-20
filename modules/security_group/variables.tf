variable "region" {
  description = "AWS London-Region"
  default     = ["eu-west-2"]
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
