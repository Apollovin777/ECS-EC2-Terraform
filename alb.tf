##### ALB - Application Load Balancing #####
##### ALB - Load Balancer #####
resource "aws_lb" "loadbalancer" {
  internal           = "false" # internal = true else false
  name               = "apollo-alb"
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets # Subnets públicas
  security_groups    = [aws_security_group.public.id]
}

##### ALB - Target Groups #####
resource "aws_alb_target_group" "alb_public_50011_target_group" {
  name     = "public-50011-tg"
  port     = "50011"
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    healthy_threshold   = "3"
    interval            = "15"
    path                = "/"
    protocol            = "HTTP"
    unhealthy_threshold = "10"
    timeout             = "10"
  }
}

resource "aws_alb_target_group" "alb_public_50010_target_group" {
  name     = "public-50010-tg"
  port     = "50010"
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    healthy_threshold   = "3"
    interval            = "15"
    path                = "/"
    protocol            = "HTTP"
    unhealthy_threshold = "10"
    timeout             = "10"
  }
}

resource "aws_lb_target_group_attachment" "attach_50011" {
  target_group_arn = aws_alb_target_group.alb_public_50011_target_group.arn
  target_id        = aws_instance.ec2_instance.id
  port             = 50011
}

resource "aws_lb_target_group_attachment" "attach_50010" {
  target_group_arn = aws_alb_target_group.alb_public_50010_target_group.arn
  target_id        = aws_instance.ec2_instance.id
  port             = 50010
}

##### ALB - Listeners #####

resource "aws_lb_listener" "lb_listener-50010" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = "50010"
  protocol          = "HTTP"  
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_public_50010_target_group.id
  }
}

resource "aws_lb_listener" "lb_listener-50011" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = "50011"
  protocol          = "HTTP"  
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_public_50011_target_group.id
  }
}

