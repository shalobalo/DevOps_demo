########################################################################################
# AMI Filter for Ubuntu 18.04 LTS amd64 Server
########################################################################################
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

########################################################################################
# Setup Lanch configuration group for docker instances in Private subnet 
# user_data_base64 = $(cat user_data.sh | base64)
########################################################################################
resource "aws_launch_configuration" "docker_nginx_conf" {
  name                    = "docker_nginx_conf"
  image_id                = data.aws_ami.ubuntu.id
  instance_type           = "t2.micro"
  security_groups         = [ aws_security_group.web_ssh.id ]
  user_data_base64        = filebase64("./scripts/user_data_docker.sh")
  key_name                = var.aws_key_name

  # user_data_base64        = "IyEvYmluL2Jhc2ggCmV4cG9ydCBERUJJQU5fRlJPTlRFTkQ9bm9uaW50ZXJhY3RpdmUKYXB0IC15IHVwZGF0ZQphcHQgLXkgdXBncmFkZQphcHQgLXkgcmVtb3ZlIGRvY2tlciBkb2NrZXItZW5naW5lIGRvY2tlci5pbwphcHQgLXkgaW5zdGFsbCBkb2NrZXIuaW8Kc3lzdGVtY3RsIHN0YXJ0IGRvY2tlcgpzeXN0ZW1jdGwgZW5hYmxlIGRvY2tlcgpkb2NrZXIgcnVuIC0tbmFtZSBlYXJuZXN0LW5naW54IC1wIDgwODA6ODAgLWQgbmdpbngK"
}

########################################################################################
# Setup Autoscaling group for docker instance
########################################################################################
resource "aws_autoscaling_group" "docker_nginx" {
  name                  = "docker_nginx"
  launch_configuration  = aws_launch_configuration.docker_nginx_conf.name
  vpc_zone_identifier   = [ aws_subnet.Pub_Subnet_a.id, aws_subnet.Pub_Subnet_b.id, aws_subnet.Pub_Subnet_c.id ]
  target_group_arns     = [ aws_lb_target_group.ProjectATG.arn ]
  desired_capacity      = 5
  min_size              = 2
  max_size              = 5
}

########################################################################################
# Spin up Bastion host in Public subnet for ssh access to Private instances (optional)
########################################################################################
resource "aws_instance" "bastion" {
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = "t2.nano"
  user_data_base64        = filebase64("./scripts/user_data_bastion.sh")
  vpc_security_group_ids  = [aws_security_group.ssh.id]
  subnet_id               = aws_subnet.Pub_Subnet_a.id
  key_name                = var.aws_key_name
  associate_public_ip_address = true
  tags = {
    Name = "Bastion"
  }
}
