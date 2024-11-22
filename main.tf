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
  profile = "Terraform-Diplom"

}

module "network" {
  source                      = "./modules/network"
  region                      = var.region
  ports                       = var.ports
  CIDR                        = var.CIDR
  defenders_vpc_cidr          = var.defenders_vpc_cidr
  defenders_public_subnet     = var.defenders_public_subnet
  defenders_sub_public_subnet = var.defenders_sub_public_subnet
  defenders_private_subnet    = var.defenders_private_subnet
  subnet_id = module.network.module_defenders_public_subnet_id
}

module "compute" {
  source    = "./modules/compute"
  region    = var.region
  inst_type = var.inst_type
  ports = var.ports
  CIDR= var.CIDR
  public_subnet_id = module.network.module_defenders_public_subnet_id
  sub_public_subnet = module.network.module_sub_defenders_public_subnet_id
  vpc_id = module.compute.module_vpc_id
}

module "load_balancer" {
  source = "./modules/load_balancer"
  region = var.region
  ports  = var.ports
  module_instance_id = module.compute.module_defender_instance_id
  public_subnet_id = module.network.module_defenders_public_subnet_id
  sub_public_subnet = module.network.module_sub_defenders_public_subnet_id
  vpc_id = module.compute.module_vpc_id
  module_alb_security_group = module.compute.module_alb_security_group_defence_id
}

module "monitoring" {
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
  module_instance_id = module.compute.module_defender_instance_id
  module_scale_out_id = module.compute.module_auto_scaling_scale_out
  module_scale_in_id = module.compute.module_auto_scaling_scale_in
}