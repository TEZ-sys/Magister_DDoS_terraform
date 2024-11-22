output "module_defender_instance_id" {
  value = aws_instance.defender_instance.id
}

output "module_defender_instance_ip" {
  value = aws_instance.defender_instance.public_ip
}

output "module_scale_out_id" {
  value= aws_autoscaling_policy.scale_out.id
}

output "module_scale_in_id" {
  value= aws_autoscaling_policy.scale_in.id
}

output "module_security_group_defence_id" {
  value = aws_security_group.defenders_security_group.id
}
output "module_alb_security_group_defence_id" {
  value = aws_security_group.alb_sg.id
}
output "module_alb_security_group" {
  value=aws_security_group.alb_sg.id
}
data "aws_availability_zones" "all" {}


data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}