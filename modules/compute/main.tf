#-----------------------------------------Defence-instance---------------------------------------
resource "aws_instance" "defender_instance" {
  count                  = var.create_resource["instance"] ? 1 : 0
  vpc_security_group_ids = [aws_security_group.defenders_security_group.id]
  ami                    = var.ami
  instance_type          = var.inst_type
  subnet_id              = var.public_subnet_id

  tags = {
    Name = "Defender"
  }
}


#-----------------------------------------Attack-instance---------------------------------------
resource "aws_instance" "atatckers_instance" {
  count                  = var.create_resource["instance"] ? 1 : 0
  vpc_security_group_ids = [aws_security_group.defenders_security_group.id]
  ami                    = var.ami
  instance_type          = var.inst_type
  subnet_id              = var.sub_public_subnet

  tags = {
    Name        = "Attacker_instance_number${count.index + 1}"
    Environment = "dev"
  }
}

#-----------------------------------------Auto-scaling-group---------------------------------------
resource "aws_launch_template" "defence_launch_template" {
  count         = var.create_resource["auto_scale"] ? 1 : 0
  name_prefix   = "Default-London-instance"
  image_id      = var.ami
  instance_type = var.inst_type
  network_interfaces {
    security_groups = [aws_security_group.defenders_security_group.id]
  }
  user_data = base64encode(<<-EOT
   #!/bin/bash
    apt-get update -y
    apt-get install nginx -y
    ufw allow 80
EOT
  )
}

resource "aws_autoscaling_group" "defence_asg" {
  count               = var.create_resource["auto_scale"] ? 1 : 0
  desired_capacity    = 1
  min_size            = 1
  max_size            = 5
  vpc_zone_identifier = [var.sub_public_subnet]

  launch_template {
    id = aws_launch_template.defence_launch_template[0].id
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  count                  = var.create_resource["monitoring"] ? 1 : 0
  name                   = "scale_out-terraform-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 50
  autoscaling_group_name = aws_autoscaling_group.defence_asg[count.index].name
}

resource "aws_autoscaling_policy" "scale_in" {
  count                  = var.create_resource["monitoring"] ? 1 : 0
  name                   = "scale-in-terraform-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 100
  autoscaling_group_name = aws_autoscaling_group.defence_asg[count.index].name
}

#---------------------------------aws_security_group-----------------------------
resource "aws_security_group" "defenders_security_group" {
  name_prefix = "Security-Group for Defenders"

  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.CIDR
    }
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.CIDR
  }

  tags = {
    Name = "Defenders_Security_group"
  }
}


resource "aws_security_group" "alb_sg" {
  count = var.create_resource["load_balance"] ? 1 : 0
  name  = "alb_sg"

  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.CIDR
    }
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.CIDR
  }

  tags = {
    Name = "alb-sg"
  }
}
