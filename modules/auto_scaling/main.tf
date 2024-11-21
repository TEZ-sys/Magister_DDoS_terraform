resource "aws_launch_template" "defence_launch_template" {

  name_prefix   = "Default-London-instance"
  image_id      = coalesce(var.ami, data.aws_ami.latest_ubuntu.id) #FIX Data for image_id
  instance_type = var.inst_type
  network_interfaces {
    security_groups = [var.module_defenders_security_group.id]
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
  vpc_zone_identifier = [var.module_defenders_public_subnet.id]

  launch_template {
    id = aws_launch_template.defence_launch_template.id
  }

  tags = [
    {
      key                 = "Name"
      value               = "defence-instance"
      propagate_at_launch = true
    }
  ]
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
