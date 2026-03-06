output "module_iam_monitoring_profile" {
  value       = var.create_resource["iam_role"] ? aws_iam_instance_profile.monitoring_profile[0].name : null
  description = "Monitoring profile"
}