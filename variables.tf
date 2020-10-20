##############################################################
# Provider Settings
##############################################################
variable "region" {
  default = "us-east-1"
}

##############################################################
# VPC Settings
##############################################################
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "instanceTenancy" {
  default = "default"
}
variable "dnsSupport" {
  default = true
}
variable "dnsHostNames" {
  default = true
}
variable "AZ_a" {
  default = "us-east-1a"
}
variable "AZ_b" {
  default = "us-east-1b"
}
variable "AZ_c" {
  default = "us-east-1c"
}
variable "priv_subnet_a_cidr" {
  default = "10.0.1.0/24"
}
variable "priv_subnet_b_cidr" {
  default = "10.0.2.0/24"
}
variable "priv_subnet_c_cidr" {
  default = "10.0.3.0/24"
}
variable "pub_subnet_a_cidr" {
  default = "10.0.100.0/24"
}
variable "pub_subnet_b_cidr" {
  default = "10.0.101.0/24"
}
variable "pub_subnet_c_cidr" {
  default = "10.0.102.0/24"
}
variable "aws_key_name" {
  default = "id_rsa"
}

##############################################################
# Security Group CIDR Settings
##############################################################
variable "egress_igw_cidr" {
  default = "0.0.0.0/0"
}
variable "ingress_ssh_cidr_list" {
  type = list
  default = [ "0.0.0.0/0" ]
}
variable "public_egress_cidr_list" {
  type = list
  default = [ "0.0.0.0/0" ]
}
variable "mapPublicIP" {
  default = true
}

##############################################################
# Create empty secret vars
##############################################################
variable "access_key" {}
variable "secret_key" {}
