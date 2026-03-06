terraform {
  backend "s3" {
    bucket  = "dfutumai-sub-terraform-tfstate"
    key     = "global/terraform.tfstate"
    region  = "eu-west-2"
    encrypt = true
  }
}