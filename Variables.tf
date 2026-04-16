#-----------------------------------general--------------------------------------------------
variable "create_resource" {
  description = "True or false to create a resource"
  type        = map(bool)
  default = {
    instance     = true
    auto_scale   = true
    load_balance = false
    monitoring   = true
    network      = true
    iam_role     = true
    sns_topic    = true
    logging      = false
    dns          = false
    s3_storage   = false
    cdn          = false
  }
}

variable "resource_owner" {
  description = "Owner of resources"
  type        = map(string)
  default = {
    name  = "dfutumai"
    owner = "dfutumai@"
  }
}

variable "profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "Terraform-AWS"
}
variable "region" {
  description = "AWS London-Region"
  type        = string
}

variable "key_name" {
  description = "Key name for EC2 instances"
  type        = string
  default     = "DevOps-IaC"
}

variable "email_address" {
  description = "Email address for sns"
  type        = string
  default     = ""
}
#-----------------------------------compute--------------------------------------------------

variable "scaleout_capacity" {
  description = "Amount of instances for each of ASG"
  type        = map(number)
  default = {
    min     = 0
    desired = 0
    max     = 0
  }
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
#-----------------------------------network--------------------------------------------------
variable "availability_zones" {
  description = "Availability zones"
  type        = map(string)
  default = {
    az1 = "eu-west-2a"
    az2 = "eu-west-2b"
    az3 = "eu-west-2c"
  }
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

#-----------------------------------monitoring--------------------------------------------------

variable "scale_in_period" {
  description = "Scale in preiod"
  type        = number
  default     = 120
}
variable "scale_out_period" {
  description = "Scale out period"
  type        = number
  default     = 60
}

variable "scale_in_threshold" {
  description = "Scale in threshold"
  type        = number
  default     = 10
}

variable "scale_out_threshold" {
  description = "Scale out threshold"
  type        = number
  default     = 20
}

variable "evaluation_periods" {
  description = "Evaluation period"
  type        = number
  default     = 2
}

variable "network_period" {
  description = "Network perido"
  type        = number
  default     = 300
}

variable "network_threshold" {
  description = "Network threshold"
  type        = number
}
variable "database_period" {
  description = "Database period"
  type        = number
  default     = 60
}

variable "metric_name" {
  type = map(string)
  default = {
    cpu           = "CPUUtilization"
    network_in    = "NetworkIn"
    network_out   = "NetworkOut"
    customDisk    = "DiskUsageRootPercent"
    customRAM     = "RAMUsed"
    customLatency = "NetworkLatency"
    customCPU     = "customCPUUtils"
  }
}

variable "comparison" {
  description = "Comparison data"
  type        = string
}

variable "name_space" {
  type = map(string)
  default = {
    ec2    = "AWS/EC2"
    custom = "Custom/System"
  }
}

variable "retention_days" {
  description = "Retention days for log group"
  type        = number
  default     = 1
}
#-----------------------------------route-53----------------------------------------------------

variable "domain_name" {
  description = "The domain name Nebotask.click"
  type        = string
  default     = "dfutumainebotask.click"
}

variable "dns_type" {
  description = "DNS record type (A, CNAME, etc.)"
  type        = string
  default     = "NS"
}

variable "dns_ttl" {
  description = "DNS record TTL"
  type        = number
  default     = 300
}

#-----------------------------------s3-storage-variables-------------------------------------------
variable "bucket_name" {
  description = "S3 Bucket name"
  type        = string
  default     = "dfutumai-bucket-nebotask"
}

variable "bucket_acl" {
  description = "S3 Bucket acl"
  type        = string
  default     = "private"
}
variable "index_document" {
  description = "S3 Object key"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "S3 Object key"
  type        = string
  default     = "error.html"
}

variable "content_type" {
  description = "S3 Object content type"
  type        = string
  default     = "text/html"
}
#-----------------------------------CDN-------------------------------------------------------------
variable "cdn_boolean" {
  description = "Owner of resources"
  type        = map(bool)
  default = {
    query_string                   = false
    cloudfront_default_certificate = false
    enabled                        = true
    is_ipv6_enabled                = true
  }
}

variable "cdn_string_config" {
  description = "CDN string config"
  type        = map(string)
  default = {
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
    forward                  = "none"
    restriction_type         = "none"
  }
}

variable "cdn_ttl" {
  description = "CDN TTL"
  type        = map(number)
  default = {
    min     = 0
    default = 3600
    max     = 86400
  }
}

variable "cdn_allowed_methods" {
  description = "CDN allowed methods"
  type        = list(string)
  default     = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
}

variable "cdn_cached_methods" {
  description = "CDN cached methods"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "cdn_viewer_protocol_policy" {
  description = "CDN viewer protocol policy"
  type        = string
  default     = "redirect-to-https"
}

variable "cdn_s3_origin" {
  description = "CDN S3 origin ID"
  type        = string
  default     = "s3-origin"
}
#----------------------------------Data Sources-----------------------------------------------------
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

locals {
  description = "Environments from workspaces"
  environment = terraform.workspace
}