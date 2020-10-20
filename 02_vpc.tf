##############################################################
# VPC
##############################################################
resource "aws_vpc" "ProjectA_VPC" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instanceTenancy 
  enable_dns_support   = var.dnsSupport 
  enable_dns_hostnames = var.dnsHostNames
  tags = {
    Name = "ProjectA_VPC"
  }
}

##############################################################
# Public Subnets
##############################################################
resource "aws_subnet" "Pub_Subnet_a" {
  vpc_id                  = aws_vpc.ProjectA_VPC.id
  cidr_block              = var.pub_subnet_a_cidr
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.AZ_a
  tags = {
    Name = "Pub_Subnet_a"
  }
}

resource "aws_subnet" "Pub_Subnet_b" {
  vpc_id                  = aws_vpc.ProjectA_VPC.id
  cidr_block              = var.pub_subnet_b_cidr
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.AZ_b
  tags = {
    Name = "Pub_Subnet_b"
  }
}

resource "aws_subnet" "Pub_Subnet_c" {
  vpc_id                  = aws_vpc.ProjectA_VPC.id
  cidr_block              = var.pub_subnet_c_cidr
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.AZ_c
  tags = {
    Name = "Pub_Subnet_c"
  }
}

##############################################################
# Private Subnets
##############################################################
resource "aws_subnet" "Priv_Subnet_a" {
  vpc_id                  = aws_vpc.ProjectA_VPC.id
  cidr_block              = var.priv_subnet_a_cidr
  availability_zone       = var.AZ_a
  tags = {
    Name = "Priv_Subnet_a"
  }
}

resource "aws_subnet" "Priv_Subnet_b" {
  vpc_id                  = aws_vpc.ProjectA_VPC.id
  cidr_block              = var.priv_subnet_b_cidr
  availability_zone       = var.AZ_b
  tags = {
    Name = "Priv_Subnet_b"
  }
}

resource "aws_subnet" "Priv_Subnet_c" {
  vpc_id                  = aws_vpc.ProjectA_VPC.id
  cidr_block              = var.priv_subnet_c_cidr
  availability_zone       = var.AZ_c
  tags = {
    Name = "Priv_Subnet_c"
  }
}

##############################################################
# Internet and NAT Gateways
##############################################################
resource "aws_internet_gateway" "ProjectA_VPC_GW" {
  vpc_id = aws_vpc.ProjectA_VPC.id
  tags = {
    Name = "ProjectA_VPC_GW"
  }
}

resource "aws_route_table" "ProjectA_VPC_IGW_route_table" {
  vpc_id = aws_vpc.ProjectA_VPC.id
  tags = {
    Name = "ProjectA_VPC_IGW_route_table"
  }
}

resource "aws_eip" "eip_nat_1" {
  vpc = true
  tags = {
    Name = "eip_nat_1"
  }
}

resource "aws_nat_gateway" "vpc_nat_1" {
  allocation_id = aws_eip.eip_nat_1.id
  subnet_id = aws_subnet.Pub_Subnet_a.id
  tags = {
    Name = "vpc_nat_1"
  }
}

##############################################################
# Routing Tables
##############################################################
resource "aws_route_table" "ProjectA_VPC_NAT_route_table" {
  vpc_id = aws_vpc.ProjectA_VPC.id
  tags = {
    Name = "ProjectA_VPC_NAT_route_table"
  }
}

resource "aws_route" "ProjectA_VPC_IGW_route" {
  route_table_id         = aws_route_table.ProjectA_VPC_IGW_route_table.id
  destination_cidr_block = var.egress_igw_cidr
  gateway_id             = aws_internet_gateway.ProjectA_VPC_GW.id
}

resource "aws_route" "ProjectA_VPC_NAT_route" {
  route_table_id         = aws_route_table.ProjectA_VPC_NAT_route_table.id
  destination_cidr_block = var.egress_igw_cidr
  nat_gateway_id         = aws_nat_gateway.vpc_nat_1.id
}

##############################################################
# IGW Routing Tables Association for Public subnets 
##############################################################
resource "aws_route_table_association" "ProjectA_VPC_association_1" {
  subnet_id      = aws_subnet.Pub_Subnet_a.id
  route_table_id = aws_route_table.ProjectA_VPC_IGW_route_table.id
}
resource "aws_route_table_association" "ProjectA_VPC_association_2" {
  subnet_id      = aws_subnet.Pub_Subnet_b.id
  route_table_id = aws_route_table.ProjectA_VPC_IGW_route_table.id
}
resource "aws_route_table_association" "ProjectA_VPC_association_3" {
  subnet_id      = aws_subnet.Pub_Subnet_c.id
  route_table_id = aws_route_table.ProjectA_VPC_IGW_route_table.id
}

##############################################################
# NAT Routing Tables Association for Private subnets 
##############################################################
resource "aws_route_table_association" "ProjectA_VPC_association_4" {
  subnet_id      = aws_subnet.Priv_Subnet_a.id
  route_table_id = aws_route_table.ProjectA_VPC_NAT_route_table.id
}
resource "aws_route_table_association" "ProjectA_VPC_association_5" {
  subnet_id      = aws_subnet.Priv_Subnet_b.id
  route_table_id = aws_route_table.ProjectA_VPC_NAT_route_table.id
}
resource "aws_route_table_association" "ProjectA_VPC_association_6" {
  subnet_id      = aws_subnet.Priv_Subnet_c.id
  route_table_id = aws_route_table.ProjectA_VPC_NAT_route_table.id
}
