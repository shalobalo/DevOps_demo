##############################################################
# Provider
##############################################################
provider "aws" {
  version = "~> 2.0"
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}
terraform {
  backend "s3" {
    bucket = "terraform-lab-07092020"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}