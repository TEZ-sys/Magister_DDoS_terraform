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
  profile = "Terraform-AWS"
}


#--------------------------------------Modules-----------------------------------
module "network" {
  create_resource            = var.create_resource
  source                     = "./modules/network"
  region                     = var.region
  availability_zones         = var.availability_zones
  ports                      = var.ports
  CIDR                       = var.CIDR
  standart_vpc_cidr          = var.standart_vpc_cidr
  standart_public_subnet     = var.standart_public_subnet
  standart_sub_public_subnet = var.standart_sub_public_subnet
  standart_private_subnet    = var.standart_private_subnet
  subnet_id                  = module.network.module_standart_public_subnet_id
  resource_owner             = var.resource_owner
}
module "iam" {
  create_resource = var.create_resource
  source          = "./modules/iam"
  resource_owner  = var.resource_owner
}
module "compute" {
  create_resource    = var.create_resource
  source             = "./modules/compute"
  region             = var.region
  inst_type          = var.inst_type
  ports              = var.ports
  CIDR               = var.CIDR
  public_subnet_id   = module.network.module_standart_public_subnet_id
  sub_public_subnet  = module.network.module_standart_sub_public_subnet_id
  vpc_id             = module.network.module_vpc_id
  scale_out_capacity = var.scaleout_capacity
  resource_owner     = var.resource_owner
}

module "load_balancer" {
  create_resource           = var.create_resource
  source                    = "./modules/load_balancer"
  region                    = var.region
  ports                     = var.ports
  module_instance_id        = module.compute.module_standart_instance_id
  public_subnet_id          = module.network.module_standart_public_subnet_id
  sub_public_subnet         = module.network.module_standart_sub_public_subnet_id
  vpc_id                    = module.network.module_vpc_id
  module_alb_security_group = module.compute.module_alb_security_group_standart_id
  resource_owner            = var.resource_owner
}

module "monitoring" {
  create_resource     = var.create_resource
  source              = "./modules/monitoring"
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
  module_instance_id  = module.compute.module_standart_instance_id
  module_scale_out_id = module.compute.module_scale_out_id
  module_scale_in_id  = module.compute.module_scale_in_id
  resource_owner      = var.resource_owner
}