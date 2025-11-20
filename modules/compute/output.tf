output "module_defender_instance_id" {
  value       = var.create_resource["compute"] ? aws_instance.defender_instance[0].id : null
  description = "ID of the defender instance"
}

output "module_defender_instance_ip" {
  value       = var.create_resource["compute"] ? aws_instance.defender_instance[0].public_ip : null
  description = "Public IP of the defender instance"
}

output "module_scale_out_id" {
  value       = var.create_resource["auto_scale"] ? aws_autoscaling_policy.scale_out[0].id : null
  description = "ID of the scale out policy"
}

output "module_scale_in_id" {
  value       = var.create_resource["auto_scale"] ? aws_autoscaling_policy.scale_in[0].id : null
  description = "ID of the scale in policy"
}

output "module_security_group_defence_id" {
  value       = aws_security_group.defenders_security_group.id
  description = "ID of the defenders security group"
}

output "module_alb_security_group_defence_id" {
  value       = var.create_resource["load_balance"] ? aws_security_group.alb_sg[0].id : null
  description = "ID of the ALB security group"
}

output "module_alb_security_group" {
  value       = var.create_resource["load_balance"] ? aws_security_group.alb_sg[0].id : null
  description = "ID of the ALB security group (duplicate for compatibility)"
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