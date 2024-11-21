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
}

module "compute" {
  source = "./modules/compute/"
}

module "auto-scaling" {
  source = "./modules/auto_scaling/"

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