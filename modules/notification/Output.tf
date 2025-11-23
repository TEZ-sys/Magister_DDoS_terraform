output "module_output_sns_topic_arn" {
  description = "The ARN of the SNS topic"
  value       = var.create_resource["sns_topic"] ? aws_sns_topic.my_topic[0].arn : null

}