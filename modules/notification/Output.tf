output "module_output_sns_alert_topic_arn" {
  description = "The ARN of the SNS Alert topic"
  value       = var.create_resource["sns_topic"] ? aws_sns_topic.my_alert_topic[0].arn : null

}

output "module_output_sns_ok_topic_arn" {
  description = "The ARN of the SNS Ok topic"
  value       = var.create_resource["sns_topic"] ? aws_sns_topic.my_ok_topic[0].arn : null

}