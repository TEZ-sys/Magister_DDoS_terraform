resource "aws_cloudwatch_log_group" "log_group" {
  count             = var.create_resource["logging"] ? 1 : 0
  name              = "nebo_log_group"
  retention_in_days = var.retention_days
  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  count          = var.create_resource["logging"] ? 1 : 0
  name           = "Nebo_log_stream"
  log_group_name = aws_cloudwatch_log_group.log_group[0].name
}

# Metric filter for ERROR logs
resource "aws_cloudwatch_log_metric_filter" "error_logs" {
  count          = var.create_resource["logging"] ? 1 : 0
  name           = "ErrorLogCount"
  log_group_name = aws_cloudwatch_log_group.log_group[0].name

  pattern = "ERROR"

  metric_transformation {
    name          = "ErrorLogCount"
    namespace     = "Custom/Logs"
    value         = "1"
    default_value = 0
  }
}

# Metric filter for high MySQL connections
resource "aws_cloudwatch_log_metric_filter" "high_mysql_connections" {
  count          = var.create_resource["logging"] ? 1 : 0
  name           = "HighMySQLConnections"
  log_group_name = aws_cloudwatch_log_group.log_group[0].name

  pattern = "High MySQL connections"

  metric_transformation {
    name          = "HighConnectionCount"
    namespace     = "Custom/Logs"
    value         = "1"
    default_value = 0
  }
}

# Metric filter for authentication failures
resource "aws_cloudwatch_log_metric_filter" "auth_failures" {
  count          = var.create_resource["logging"] ? 1 : 0
  name           = "AuthenticationFailures"
  log_group_name = aws_cloudwatch_log_group.log_group[0].name

  pattern = "Failed password"

  metric_transformation {
    name          = "AuthFailureCount"
    namespace     = "Custom/Security"
    value         = "1"
    default_value = 0
  }
}
# Metric filter for Test Alerts
resource "aws_cloudwatch_log_metric_filter" "test_alerts" {
  count          = var.create_resource["logging"] ? 1 : 0
  name           = "TestAlertCount"
  log_group_name = aws_cloudwatch_log_group.log_group[0].name

  # This matches the specific string from your echo command
  pattern = "\"This is a test error\""

  metric_transformation {
    name          = "TestAlertCount"
    namespace     = "Custom/Logs"
    value         = "1"
    default_value = 0
  }
}