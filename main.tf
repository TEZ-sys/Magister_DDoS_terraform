terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.49.0"
    }
  }
}

#-----------------------------------provider_"aws" ------------------------------
provider "aws" {
  region  = var.region
  profile = var.profile
}
#Deploy S3 for CDN with HTML

locals {
  environment = terraform.workspace
}

#--------------------------------------Modules-----------------------------------
module "network" {
  source             = "./modules/network"
  create_resource    = var.create_resource
  region             = var.region
  availability_zones = var.availability_zones
  ports              = var.ports
  CIDR               = var.CIDR
  vpc_cidr           = var.vpc_cidr
  public_subnet      = var.public_subnet
  sub_public_subnet  = var.sub_public_subnet
  private_subnet     = var.private_subnet
  subnet_id          = module.network.module_public_subnet_id
  resource_owner     = var.resource_owner
  environment        = var.environment
}

module "notification" {
  source          = "./modules/notification"
  resource_owner  = var.resource_owner
  create_resource = var.create_resource
  email_address   = var.email_address
  environment     = var.environment

}

module "iam" {
  source          = "./modules/iam"
  create_resource = var.create_resource
  resource_owner  = var.resource_owner
  environment     = var.environment

}

module "compute" {
  source             = "./modules/compute"
  create_resource    = var.create_resource
  region             = var.region
  inst_type          = var.inst_type
  ami                = data.aws_ami.latest_ubuntu.id
  ports              = var.ports
  CIDR               = var.CIDR
  public_subnet_id   = module.network.module_public_subnet_id
  sub_public_subnet  = module.network.module_sub_public_subnet_id
  vpc_id             = module.network.module_vpc_id
  scale_out_capacity = var.scaleout_capacity
  resource_owner     = var.resource_owner
  monitoring_profile = module.iam.module_iam_monitoring_profile
  environment        = var.environment
  key_name           = var.key_name

}

module "load_balancer" {
  source                    = "./modules/load_balancer"
  create_resource           = var.create_resource
  region                    = var.region
  ports                     = var.ports
  module_instance_id        = module.compute.module_instance_id
  public_subnet_id          = module.network.module_public_subnet_id
  sub_public_subnet         = module.network.module_sub_public_subnet_id
  vpc_id                    = module.network.module_vpc_id
  module_alb_security_group = module.compute.module_alb_security_group_id
  resource_owner            = var.resource_owner
  environment               = var.environment

}

module "monitoring" {
  source              = "./modules/monitoring"
  create_resource     = var.create_resource
  name_space          = var.name_space
  scale_in_period     = var.scale_in_period
  scale_in_threshold  = var.scale_in_threshold
  scale_out_period    = var.scale_out_period
  scale_out_threshold = var.scale_out_threshold
  evaluation_periods  = var.evaluation_periods
  network_period      = var.network_period
  network_threshold   = var.network_threshold
  metric_name         = var.metric_name
  comparison          = var.comparison
  module_instance_id  = module.compute.module_instance_id
  module_scale_out_id = module.compute.module_scale_out_id
  module_scale_in_id  = module.compute.module_scale_in_id
  resource_owner      = var.resource_owner
  sns_alert_topic_arn = module.notification.module_output_sns_alert_topic_arn
  sns_ok_topic_arn    = module.notification.module_output_sns_ok_topic_arn
  environment         = var.environment

}

module "logging" {
  source          = "./modules/logging"
  create_resource = var.create_resource
  sns_topic_arn   = module.notification.module_output_sns_alert_topic_arn
  resource_owner  = var.resource_owner
  retention_days  = var.retention_days
  environment     = var.environment

}