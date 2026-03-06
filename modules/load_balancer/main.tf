#-------------------------------------------Application-load-balancer----------------------------------------------------------
resource "aws_lb" "alb" {
  count              = var.create_resource["load_balance"] ? 1 : 0
  name               = "standart-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [var.module_alb_security_group]
  subnets            = [var.public_subnet_id, var.sub_public_subnet]

  enable_deletion_protection = false
  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "target_group" {
  count       = var.create_resource["load_balance"] ? 1 : 0
  name        = "standart-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}

resource "aws_lb_target_group_attachment" "target_attachment" {
  count            = var.create_resource["load_balance"] ? 1 : 0
  target_group_arn = aws_lb_target_group.target_group[0].arn
  target_id        = var.module_instance_id
  port             = 80
}


resource "aws_lb_listener" "http_listener" {
  count             = var.create_resource["load_balance"] ? 1 : 0
  load_balancer_arn = aws_lb.alb[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group[0].arn
  }
}

