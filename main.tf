terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.5.0"
    }
  }
}

#-----------------------------------provider_"aws" ------------------------------
provider "aws" {
  region  = var.region[0]
  profile = "Terraform-Diplom"

}

module "network" {
  source = "./modules/network/"
  defenders_vpc_cidr       = var.defenders_vpc_cidr
  defenders_public_subnet  = var.defenders_public_subnet
  defenders_private_subnet = var.defenders_private_subnet
  defenders_sub_public_subnet = var.defenders_sub_public_subnet
}

module "compute" {
  source = "./modules/compute/"
}

module "auto-scaling" {
  source = "./modules/auto-scaling/"

}

module "load_balancer" {
  source = "./modules/load_balancer/"
}

module "monitoring" {
  source = "./modules/monitoring/"
}

module "security_group" {
  source = "./modules/security_group/"
}