#-------------------------------------------Application-load-balancer----------------------------------------------------------
resource "aws_lb" "alb" {
  name               = "defensive-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [var.module_alb_security_group]
  subnets            = [var.public_subnet_id, var.sub_public_subnet]

  enable_deletion_protection = false
  tags = {
    Name = "defensive-alb"
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "defense-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${var.vpc_id}"
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
    Name = "defense-target-group"
  }
}

resource "aws_lb_target_group_attachment" "target_attachment" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = "${var.module_defender_instance.id}"
  port             = 80
}


resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

