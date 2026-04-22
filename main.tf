terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.34.0"
    }
  }
}

#-----------------------------------provider_"aws" ------------------------------
provider "aws" {
  region  = var.region
  profile = var.profile
}

provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
  profile = var.profile
}
#--------------------------------------Modules-----------------------------------
module "cdn" {
  source                     = "./modules/cdn"
  create_resource            = var.create_resource
  bucket_name                = module.s3_storage.module_s3_bucket_name
  cdn_s3_link                = module.s3_storage.module_s3_bucket_regional_domain
  cdn_allowed_methods        = var.cdn_allowed_methods
  cdn_cached_methods         = var.cdn_cached_methods
  cdn_ttl                    = var.cdn_ttl
  cdn_viewer_protocol_policy = var.cdn_viewer_protocol_policy
  cdn_s3_origin              = var.cdn_s3_origin
  cdn_certificate_arn        = module.certs.cdn_certificate_arn
  index_document             = var.index_document
  cdn_boolean                = var.cdn_boolean
  cdn_string_config          = var.cdn_string_config
  resource_owner             = var.resource_owner
  environment                = local.environment
  domain_name                = var.domain_name
  providers = {
    aws.ssl = aws.us_east_1
  }
}
module "certs" {
  source          = "./modules/certs"
  create_resource = var.create_resource
  domain_name     = var.domain_name
  zone_id         = module.domain.module_route53_zone_id
  resource_owner  = var.resource_owner
  environment     = local.environment
  providers = {
    aws.ssl = aws.us_east_1
    aws     = aws
  }

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
  custom_instance_profile = module.iam.module_iam_custom_profile
  environment        = local.environment
  key_name           = var.key_name

}

module "domain" {
  source             = "./modules/domain"
  create_resource    = var.create_resource
  domain_name        = var.domain_name
  dns_type           = var.dns_type
  dns_ttl            = var.dns_ttl
  vpc_id             = module.network.module_vpc_id
  vpc_region         = var.region
  resource_owner     = var.resource_owner
  environment        = local.environment
  cdn_domain_name    = module.cdn.module_cdn_domain_name
  cdn_hosted_zone_id = module.cdn.module_cdn_hosted_zone_id
  providers = {
    aws.ssl = aws.us_east_1
  }
}

module "iam" {
  source          = "./modules/iam"
  region          = var.region
  create_resource = var.create_resource
  resource_owner  = var.resource_owner
  environment     = local.environment
  secrets_arn     = var.secret_arn

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
  environment               = local.environment

}

module "logging" {
  source          = "./modules/logging"
  create_resource = var.create_resource
  sns_topic_arn   = module.notification.module_output_sns_alert_topic_arn
  resource_owner  = var.resource_owner
  retention_days  = var.retention_days
  environment     = local.environment

}

module "monitoring" {
  source                 = "./modules/monitoring"
  create_resource        = var.create_resource
  name_space             = var.name_space
  scale_in_period        = var.scale_in_period
  scale_in_threshold     = var.scale_in_threshold
  scale_out_period       = var.scale_out_period
  scale_out_threshold    = var.scale_out_threshold
  database_period        = var.database_period
  evaluation_periods     = var.evaluation_periods
  network_period         = var.network_period
  network_threshold      = var.network_threshold
  metric_name            = var.metric_name
  comparison             = var.comparison
  module_instance_id     = module.compute.module_instance_id
  module_sub_instance_id = module.compute.module_sub_instance_id
  module_scale_out_id    = module.compute.module_scale_out_id
  module_scale_in_id     = module.compute.module_scale_in_id
  resource_owner         = var.resource_owner
  sns_alert_topic_arn    = module.notification.module_output_sns_alert_topic_arn
  sns_ok_topic_arn       = module.notification.module_output_sns_ok_topic_arn
  environment            = local.environment

}

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
  environment        = local.environment
}

module "notification" {
  source          = "./modules/notification"
  resource_owner  = var.resource_owner
  create_resource = var.create_resource
  email_address   = var.email_address
  environment     = local.environment

}

module "s3_storage" {
  source          = "./modules/s3_storage"
  bucket_name     = var.bucket_name
  bucket_acl      = var.bucket_acl
  index_document  = var.index_document
  error_document  = var.error_document
  content_type    = var.content_type
  cloudfront_oai  = module.cdn.module_cloudfront_oai_iam_arn
  create_resource = var.create_resource
  resource_owner  = var.resource_owner
  environment     = local.environment

}