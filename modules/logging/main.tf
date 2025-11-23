resource "aws_cloudwatch_log_group" "log_group" {
  count             = var.create_resource["logging"] ? 1 : 0
  name              = "nebo_log_group"
  retention_in_days = var.retention_days
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  count          = var.create_resource["logging"] ? 1 : 0
  name           = "Nebo_log_stream"
  log_group_name = aws_cloudwatch_log_group.log_group[0].name
}