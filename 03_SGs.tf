########################################################################################
# SG for Public ALB ( VPC_CIDR -> ALB:80 / ALB -> VPC_CIDR:0 )
########################################################################################
resource "aws_security_group" "public_alb_80" {
  vpc_id        = aws_vpc.ProjectA_VPC.id
  name          = "public_alb_80"
  description   = "Allow Access to public ALB on port 80"
  
  ingress {
    cidr_blocks = var.public_egress_cidr_list
    from_port   = 80
    to_port     = 80
    description = "HTTP"
    protocol    = "tcp"
  } 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.public_egress_cidr_list
  }
  tags = {
    Name = "public_alb_80"
  }
}

########################################################################################
# web & ssh SG for VPC ( vpc_cidr -> VPC:8080,22 / VPC:0 -> 0.0.0.0/0:0 )
########################################################################################
resource "aws_security_group" "web_ssh" {
  vpc_id        = aws_vpc.ProjectA_VPC.id
  name          = "web_ssh"
  description   = "Allow Access to port 8080 and 22 for Instances"
  
  ingress {
    cidr_blocks = [ var.vpc_cidr ]
    from_port   = 8080
    to_port     = 8080
    description = "HTTP"
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = [ var.vpc_cidr ]
    from_port   = 22
    to_port     = 22
    description = "SSH"
    protocol    = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.public_egress_cidr_list
  }
  tags = {
    Name        = "web_ssh"
    Description = "Allow Access to port 8080 and 22 for Instances"
  }
}

########################################################################################
# SG ALB to web & ssh ( ALB -> VPC:8080 / none )
########################################################################################
resource "aws_security_group_rule" "web_from_alb" {
  type                      = "ingress"
  from_port                 = 8080
  to_port                   = 8080
  protocol                  = "tcp"
  source_security_group_id  = aws_security_group.public_alb_80.id
  security_group_id         = aws_security_group.web_ssh.id
}

########################################################################################
# SSH SG for Public Subnets ( 0.0.0.0/0 -> Pub:22 / Pub:0 -> 0.0.0.0/0:0 )
########################################################################################
resource "aws_security_group" "ssh" {
  vpc_id        = aws_vpc.ProjectA_VPC.id
  name          = "ssh"
  description   = "Allow Access to Public subnets from the Internet on port 22"
  
  ingress {
    cidr_blocks = var.ingress_ssh_cidr_list
    from_port   = 22
    to_port     = 22
    description = "ssh"
    protocol    = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.public_egress_cidr_list
  }
  tags = {
    Name        = "ssh"
  }
}
