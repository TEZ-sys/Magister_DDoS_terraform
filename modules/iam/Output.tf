output "module_iam_monitoring_profile" {
  value       = var.create_resource["iam_role"] ? aws_iam_instance_profile.monitoring_profile[0].name : null
  description = "Monitoring profile"
}

output "module_iam_custom_profile" {
  value       = var.create_resource["iam_role_custom"] ? aws_iam_instance_profile.ec2_mysql_profile[0].name : null
  description = "Custom EC2 instance profile for Secrets Manager access"
}