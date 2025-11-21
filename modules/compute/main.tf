#-----------------------------------------standart-instance---------------------------------------
resource "aws_instance" "standart_instance" {
  count                  = var.create_resource["instance"] ? 1 : 0
  vpc_security_group_ids = [aws_security_group.standart_security_group[count.index].id]
  ami                    = var.ami != "" ? var.ami : data.aws_ami.latest_ubuntu.id
  instance_type          = var.inst_type
  subnet_id              = var.public_subnet_id
  user_data = base64encode(<<-EOF
#!/bin/bash

# Update packages
apt-get update -y

# Install AWS CLI
apt-get install -y awscli

# Create script directory
mkdir -p /usr/local/bin/

# Create disk publishing script
cat << 'EOT' > /usr/local/bin/publish_disk_metrics.sh
#!/bin/bash

NAMESPACE="Custom/System"
ENVIRONMENT="prod"
HOSTNAME=$(hostname)

DISK_USED=$(df / | tail -1 | awk '{print $5}' | tr -d '%')

aws cloudwatch put-metric-data \
  --namespace "$NAMESPACE" \
  --metric-name "DiskUsageRootPercent" \
  --value "$DISK_USED" \
  --unit Percent \
  --dimensions Environment=$ENVIRONMENT,Host=$HOSTNAME
EOT

chmod +x /usr/local/bin/publish_disk_metrics.sh

# Add cron job to run every 1 minute
(crontab -l 2>/dev/null; echo "*/1 * * * * /usr/local/bin/publish_disk_metrics.sh") | crontab -

EOF
  )
  tags = {
    Name        = "${var.resource_owner["name"]}-instance"
    Owner       = "${var.resource_owner["owner"]}"
    Environment = "${var.resource_owner["Prod_Environment"]}"
  }
}


#-----------------------------------------Sub-instance---------------------------------------
resource "aws_instance" "sub_instance" {
  count                  = var.create_resource["instance"] ? 1 : 0
  vpc_security_group_ids = [aws_security_group.standart_security_group[count.index].id]
  ami                    = var.ami != "" ? var.ami : data.aws_ami.latest_ubuntu.id
  instance_type          = var.inst_type
  subnet_id              = var.sub_public_subnet

  tags = {
    Name        = "${var.resource_owner["name"]}-instance"
    Owner       = "${var.resource_owner["owner"]}"
    Environment = "${var.resource_owner["Stage_Environment"]}"
  }
}

#-----------------------------------------Auto-scaling-group---------------------------------------
resource "aws_launch_template" "standart_launch_template" {
  count         = var.create_resource["auto_scale"] ? 1 : 0
  name_prefix   = "Default-London-instance"
  image_id      = var.ami != "" ? var.ami : data.aws_ami.latest_ubuntu.id
  instance_type = var.inst_type
  network_interfaces {
    security_groups = [aws_security_group.standart_security_group[count.index].id]
  }
  user_data = base64encode(<<-EOT
   #!/bin/bash
    apt-get update -y
    apt-get install nginx -y
    ufw allow 80
EOT
  )
  tags = {
    Name        = "${var.resource_owner["name"]}-Launch-template"
    Owner       = "${var.resource_owner["owner"]}"
    Environment = "${var.resource_owner["Prod_Environment"]}"
  }
}

resource "aws_autoscaling_group" "standart_asg" {
  count               = var.create_resource["auto_scale"] ? 1 : 0
  desired_capacity    = var.scale_out_capacity["desired"]
  min_size            = var.scale_out_capacity["min"]
  max_size            = var.scale_out_capacity["max"]
  vpc_zone_identifier = [var.sub_public_subnet]

  launch_template {
    id = aws_launch_template.standart_launch_template[0].id
  }
  tags = [{
    key   = "Name"
    value = "${var.resource_owner["name"]}-ASG"
    },
    {
      key   = "Owner"
      value = "${var.resource_owner["owner"]}"
    },
    {
      key   = "Environment"
      value = "${var.resource_owner["Prod_Environment"]}"
  }]
}

resource "aws_autoscaling_policy" "scale_out" {
  count                  = var.create_resource["monitoring"] ? 1 : 0
  name                   = "scale_out-terraform-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 50
  autoscaling_group_name = aws_autoscaling_group.standart_asg[count.index].name
}

resource "aws_autoscaling_policy" "scale_in" {
  count                  = var.create_resource["monitoring"] ? 1 : 0
  name                   = "scale-in-terraform-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 100
  autoscaling_group_name = aws_autoscaling_group.standart_asg[count.index].name
}

#---------------------------------aws_security_group-----------------------------
resource "aws_security_group" "standart_security_group" {
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
    Name        = "${var.resource_owner["name"]}-Security-Group"
    Owner       = "${var.resource_owner["owner"]}"
    Environment = "${var.resource_owner["Prod_Environment"]}"
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
    Name        = "${var.resource_owner["name"]}-ALB-Security-Group"
    Owner       = "${var.resource_owner["owner"]}"
    Environment = "${var.resource_owner["Prod_Environment"]}"
  }
}
