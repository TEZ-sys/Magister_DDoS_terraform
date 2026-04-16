#-----------------------------------Monitoring-CPU-Scale-In-----------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "monitoring_cpu_scale_in" {
  count                     = var.create_resource["monitoring"] ? 1 : 0
  alarm_name                = "scale-in-monitoring-cpu"
  comparison_operator       = var.comparison
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name["cpu"]
  namespace                 = var.name_space["ec2"]
  period                    = var.scale_in_period
  statistic                 = "Average"
  threshold                 = var.scale_in_threshold
  alarm_description         = "This metric monitors ec2 cpu utilization (Scale in Event)"
  insufficient_data_actions = []

  dimensions = {
    InstanceId = "${var.module_instance_id}"
  }
  alarm_actions = [var.module_scale_in_id]

  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}

#-----------------------------------Monitoring-CPU-Scale-Out-----------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "monitoring_cpu_scale_out" {
  count = var.create_resource["monitoring"] ? 1 : 0

  alarm_name                = "scale-out-monitoring-cpu"
  comparison_operator       = var.comparison
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name["cpu"]
  namespace                 = var.name_space["ec2"]
  period                    = var.scale_out_period
  statistic                 = "Average"
  threshold                 = var.scale_out_threshold
  alarm_description         = "This metric monitors ec2 cpu utilization (Scale out event)"
  insufficient_data_actions = []

  dimensions = {
    InstanceId = "${var.module_instance_id}"
  }
  alarm_actions = [var.module_scale_out_id]
  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}

#-----------------------------------Monitoring-Network--In-----------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "monitoring_custom_metric" {
  count = var.create_resource["monitoring"] ? 1 : 0

  alarm_name          = "High-Custom-Metric"
  comparison_operator = var.comparison
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name["customCPU"]
  namespace           = var.name_space["custom"]
  period              = var.network_period
  statistic           = "Average"
  threshold           = var.network_threshold
  alarm_description   = "Triggers if Custom metric exceeds the threshold."

  dimensions = {
    InstanceId = "${var.module_instance_id}"
  }

  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}
#-----------------------------------Monitoring-Network--Out-----------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "monitoring_network_out" {
  count = var.create_resource["monitoring"] ? 1 : 0

  alarm_name          = "High-Network-Out"
  comparison_operator = var.comparison
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name["network_out"]
  namespace           = var.name_space["ec2"]
  period              = var.network_period
  statistic           = "Average"
  threshold           = var.network_threshold
  alarm_description   = "Triggers if NetworkOut exceeds the threshold."

  dimensions = {
    InstanceId = "${var.module_instance_id}"
  }
  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}

#----------------------------------CloudWatch+SNS-----------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "Cloud_watch_and_sns" {
  count                     = var.create_resource["sns_topic"] ? 1 : 0
  alarm_name                = "standart-monitoring-cpu"
  comparison_operator       = var.comparison
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name["cpu"]
  namespace                 = var.name_space["ec2"]
  period                    = var.scale_in_period
  statistic                 = "Average"
  threshold                 = 0.0
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []

  dimensions = {
    InstanceId = "${var.module_instance_id}"
  }
  alarm_actions = [var.sns_alert_topic_arn]
  ok_actions    = [var.sns_ok_topic_arn]

  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}


#-------------------------------------Custom---Metric-DashBoard-----------------------------------------
resource "aws_cloudwatch_metric_alarm" "monitoring_ram_usage" {
  count = var.create_resource["monitoring"] ? 1 : 0

  alarm_name          = "High-RAM-Usage"
  comparison_operator = var.comparison
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name["customRAM"]
  namespace           = var.name_space["custom"]
  period              = var.network_period
  statistic           = "Average"
  threshold           = 10
  alarm_description   = "Triggers if RAM usage exceeds the threshold."

  dimensions = {
    InstanceId = "${var.module_instance_id}"
  }

  alarm_actions = [var.sns_alert_topic_arn]
  ok_actions    = [var.sns_ok_topic_arn]

  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}

resource "aws_cloudwatch_metric_alarm" "monitoring_disk_usage" {
  count = var.create_resource["monitoring"] ? 1 : 0

  alarm_name          = "High-Disk-Usage"
  comparison_operator = var.comparison
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name["customDisk"]
  namespace           = var.name_space["custom"]
  period              = var.network_period
  statistic           = "Average"
  threshold           = 10
  alarm_description   = "Triggers if Disk usage exceeds the threshold."

  dimensions = {
    InstanceId = "${var.module_instance_id}"
  }

  alarm_actions = [var.sns_alert_topic_arn]
  ok_actions    = [var.sns_ok_topic_arn]

  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}


resource "aws_cloudwatch_metric_alarm" "monitoring_latency" {
  count = var.create_resource["monitoring"] ? 1 : 0

  alarm_name          = "High-Latency"
  comparison_operator = var.comparison
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name["customLatency"]
  namespace           = var.name_space["custom"]
  period              = var.network_period
  statistic           = "Average"
  threshold           = 10
  alarm_description   = "Triggers if Latency exceeds the threshold."

  dimensions = {
    InstanceId = "${var.module_instance_id}"
  }
  alarm_actions = [var.sns_alert_topic_arn]
  ok_actions    = [var.sns_ok_topic_arn]

  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}


#-------------------------------------Custom---Metric-DashBoard---Database--------------------------------------

resource "aws_cloudwatch_metric_alarm" "mysql_high_connections" {
  count               = var.create_resource["monitoring"] ? 1 : 0
  alarm_name          = "mysql-high-connections"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MySQLActiveConnections"
  namespace           = var.name_space["custom"]
  period              = 60
  statistic           = "Average"
  threshold           = 100 # Adjust based on max_connections
  alarm_description   = "MySQL connection count is high"

  dimensions = {
    InstanceId = "${var.module_instance_id}"
    Database   = "mysql"
  }

  alarm_actions = [var.sns_alert_topic_arn]
  ok_actions    = [var.sns_ok_topic_arn]

  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}

resource "aws_cloudwatch_metric_alarm" "mysql_slow_queries" {
  count               = var.create_resource["monitoring"] ? 1 : 0
  alarm_name          = "mysql-slow-queries"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MySQLSlowQueries"
  namespace           = "Custom/Application"
  period              = var.database_period
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "Too many slow queries detected"

  dimensions = {
    InstanceId = "${var.module_instance_id}"
    Database   = "mysql"
  }

  alarm_actions = [var.sns_alert_topic_arn]

  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}


# Alarm for high error rate from logs
resource "aws_cloudwatch_metric_alarm" "error_log_alarm" {
  count               = var.create_resource["logging"] ? 1 : 0
  alarm_name          = "Test-High-Error-Count"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ErrorLogCount"
  namespace           = "Custom/Logs"
  period              = var.database_period
  statistic           = "Sum"
  threshold           = 5
  alarm_description   = "High number of errors detected in logs"
  treat_missing_data  = "notBreaching"
  dimensions = {
    InstanceId = "${var.module_instance_id}"
  }
  alarm_actions = [var.sns_alert_topic_arn]
  ok_actions    = [var.sns_ok_topic_arn]

  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_metric_filter" "error_log_filter" {
  count               = var.create_resource["monitoring"] ? 1 : 0
  name           = "ErrorCountFilter"
  pattern        = "\"Test alert\""
  log_group_name = "/ubuntu/logs"

  metric_transformation {
    name      = "ErrorLogCount"   
    namespace = "Custom/Logs"
    value     = "1"
  }
}

resource "aws_cloudwatch_dashboard" "main_monitoring" {
  count          = var.create_resource["monitoring"] ? 1 : 0
  dashboard_name = "${var.environment}-System-Health"
  
  dashboard_body = jsonencode({
    widgets = [
      # CPU Utilization
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            for id in compact([var.module_instance_id, var.module_sub_instance_id]) : 
            [ var.name_space["ec2"], var.metric_name["cpu"], "InstanceId", id ]
          ]
          period = tonumber(var.scale_in_period) 
          stat   = "Average"
          region = "eu-west-2"
          title  = "CPU Utilization"
        }
      },
      # RAM Usage
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            for id in compact([var.module_instance_id, var.module_sub_instance_id]) : 
            [ var.name_space["custom"], var.metric_name["customRAM"], "InstanceId", id ]
          ]
          period = 60
          stat   = "Average"
          region = "eu-west-2"
          title  = "Memory (RAM) Usage"
        }
      },
      # NETWORK
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            for id in compact([var.module_instance_id, var.module_sub_instance_id]) : 
            [ var.name_space["ec2"], var.metric_name["network_out"], "InstanceId", id ]
          ]
          period = tonumber(var.network_period)
          stat   = "Average"
          region = "eu-west-2"
          title  = "Network Outbound"
        }
      },
      # DB Performance
      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 12
        height = 6
        properties = {
          # Explicitly building the list of lists to avoid "flatten" logic errors
          metrics = concat(
            [for id in compact([var.module_instance_id, var.module_sub_instance_id]) : [ var.name_space["custom"], "MySQLActiveConnections", "InstanceId", id, "Database", "mysql" ]],
            [for id in compact([var.module_instance_id, var.module_sub_instance_id]) : [ "Custom/Application", "MySQLSlowQueries", "InstanceId", id, "Database", "mysql" ]]
          )
          period = 60
          stat   = "Sum"
          region = "eu-west-2"
          title  = "MySQL Performance"
        }
      },
      # Error Logs
      {
        type   = "metric"
        x      = 12
        y      = 12
        width  = 12
        height = 6
        properties = {
          metrics = [
            for id in compact([var.module_instance_id, var.module_sub_instance_id]) : 
            [ "Custom/Logs", "ErrorLogCount", "InstanceId", id ]
          ]
          period = 60
          stat   = "Sum"
          region = "eu-west-2"
          title  = "Error Log Frequency"
        } 
      },
      {
        type   = "metric"
        x      = 8
        y      = 6
        width  = 8
        height = 6
        properties = {
          metrics = [
            for id in compact([var.module_instance_id, var.module_sub_instance_id]) : 
            [ "Custom/System", "DiskUsageRootPercent", "InstanceId", id ]
          ]
          period = tonumber(var.network_period)
          stat   = "Average"
          region = "eu-west-2"
          title  = "Disk Usage (Root Partition %)"
          view   = "timeSeries"
          stacked = false
        }
      }
    ]
  })
}