locals {
  merged_tags = merge(
    var.resource_owner,
    {
      Environment = var.environment
    }
  )
}

#-----------------------------------------standart-instance---------------------------------------
resource "aws_instance" "instance" {
  count                  = var.create_resource["instance"] ? 1 : 0
  vpc_security_group_ids = [aws_security_group.security_group[count.index].id]
  ami                    = var.ami
  instance_type          = var.inst_type
  subnet_id              = var.public_subnet_id
  iam_instance_profile   = var.monitoring_profile

  key_name = var.key_name
  user_data = templatefile("${path.root}/scripts/script.sh",
    {
      environment = var.environment
      region      = var.region
  })
  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}


#-----------------------------------------Sub-instance---------------------------------------
resource "aws_instance" "sub_instance" {
  count                  = var.create_resource["instance"] ? 1 : 0
  vpc_security_group_ids = [aws_security_group.security_group[count.index].id]
  ami                    = var.ami
  instance_type          = var.inst_type
  subnet_id              = var.sub_public_subnet
  iam_instance_profile   = var.monitoring_profile

  key_name = var.key_name
  user_data = templatefile("${path.root}/scripts/script.sh",
    {
      environment = var.environment
      region      = var.region
  })

  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}

#-----------------------------------------sub-2-instance---------------------------------------
resource "aws_instance" "sub_instance_2" {
  count                  = var.create_resource["instance_custom"] ? 1 : 0
  vpc_security_group_ids = [aws_security_group.security_group_for_db[count.index].id]
  ami                    = var.ami
  instance_type          = var.inst_type
  subnet_id              = var.public_subnet_id
  iam_instance_profile = var.custom_instance_profile

  key_name = var.key_name
  user_data = templatefile("${path.root}/scripts/install_db.sh",
    {
      region = var.region
      environment = var.environment
  })

  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}



#-----------------------------------------Auto-scaling-group---------------------------------------
resource "aws_launch_template" "launch_template" {
  count         = var.create_resource["auto_scale"] ? 1 : 0
  name_prefix   = "Default-London-instance"
  image_id      = var.ami
  instance_type = var.inst_type
  network_interfaces {
    security_groups = [aws_security_group.security_group[count.index].id]
  }

  user_data = templatefile("${path.root}/scripts/script.sh",
    {
      environment = var.environment
      region      = var.region
  })

  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}


resource "aws_autoscaling_group" "asg" {
  count               = var.create_resource["auto_scale"] ? 1 : 0
  desired_capacity    = var.scale_out_capacity["desired"]
  min_size            = var.scale_out_capacity["min"]
  max_size            = var.scale_out_capacity["max"]
  vpc_zone_identifier = [var.sub_public_subnet]

  launch_template {
    id = aws_launch_template.launch_template[0].id
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  count                  = var.create_resource["monitoring"] ? 1 : 0
  name                   = "scale_out-terraform-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 50
  autoscaling_group_name = aws_autoscaling_group.asg[count.index].name
}

resource "aws_autoscaling_policy" "scale_in" {
  count                  = var.create_resource["monitoring"] ? 1 : 0
  name                   = "scale-in-terraform-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 100
  autoscaling_group_name = aws_autoscaling_group.asg[count.index].name
}

#---------------------------------aws_security_group-----------------------------
resource "aws_security_group" "security_group" {
  count       = var.create_resource["instance"] ? 1 : 0
  name_prefix = "Security-Group for standart"

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
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}

resource "aws_security_group" "security_group_for_db" {
  count       = var.create_resource["instance_custom"] ? 1 : 0
  name_prefix = "Security-Group for standart"

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
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
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
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}
