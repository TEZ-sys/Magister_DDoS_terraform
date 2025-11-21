output "module_standart_instance_id" {
  value       = var.create_resource["instance"] ? aws_instance.standart_instance[0].id : null
  description = "ID of the standart instance"
}

output "module_standart_instance_ip" {
  value       = var.create_resource["instance"] ? aws_instance.standart_instance[0].public_ip : null
  description = "Public IP of the standart instance"
}

output "module_scale_out_id" {
  value       = var.create_resource["auto_scale"] ? aws_autoscaling_policy.scale_out[0].id : null
  description = "ID of the scale out policy"
}

output "module_scale_in_id" {
  value       = var.create_resource["auto_scale"] ? aws_autoscaling_policy.scale_in[0].id : null
  description = "ID of the scale in policy"
}

output "module_security_group_standart_id" {
  value       = var.create_resource["instance"] ? aws_security_group.standart_security_group[0].id : null
  description = "ID of the standart security group"
}

output "module_alb_security_group_standart_id" {
  value       = var.create_resource["load_balance"] ? aws_security_group.alb_sg[0].id : null
  description = "ID of the ALB security group"
}

output "module_alb_security_group" {
  value       = var.create_resource["load_balance"] ? aws_security_group.alb_sg[0].id : null
  description = "ID of the ALB security group (duplicate for compatibility)"
}

