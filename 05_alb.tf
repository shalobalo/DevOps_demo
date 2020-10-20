########################################################################################
# Setup ALB target group, point on port 8080
########################################################################################
resource "aws_lb_target_group" "ProjectATG" {
  name     = "ProjectATG"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.ProjectA_VPC.id
  health_check {
    interval = 5
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}
########################################################################################
# Create public ELB/ALB with private subnets
########################################################################################
resource "aws_lb" "ProjectAALB" {
  name               = "ProjectAALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ aws_security_group.public_alb_80.id ]
  subnets            = [ aws_subnet.Pub_Subnet_a.id, aws_subnet.Pub_Subnet_b.id, aws_subnet.Pub_Subnet_c.id ]
  tags = {
    Name = "ProjectAALB"
    App = "docker-nginx"
  }
}

########################################################################################
# Set ALB listener and Target group
########################################################################################
resource "aws_alb_listener" "ProjectAALB_listener" {  
  load_balancer_arn = aws_lb.ProjectAALB.arn
  port              = "80"  
  protocol          = "HTTP"
  default_action {    
    target_group_arn = aws_lb_target_group.ProjectATG.arn
    type             = "forward"  
  }
}
