#----------------------------------standart-Monitoring-CPU-Scale-In-----------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "standart_monitoring_cpu_scale_in" {
  count                     = var.create_resource["monitoring"] ? 1 : 0
  alarm_name                = "standart-monitoring-cpu"
  comparison_operator       = var.comparison
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name[0]
  namespace                 = var.name_space
  period                    = var.scale_in_period
  statistic                 = "Average"
  threshold                 = var.scale_in_threshold
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []

  dimensions = {
    InstanceId = "${var.module_instance_id}"
  }
  alarm_actions = [var.module_scale_in_id]

  tags = merge(var.resource_owner, {
    Environment = var.environment == "production" ? "production" : "stage"


  }, )
}

#----------------------------------standart-Monitoring-CPU-Scale-Out-----------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "standart_monitoring_cpu_scale_out" {
  count = var.create_resource["monitoring"] ? 1 : 0

  alarm_name                = "standart-monitoring-cpu"
  comparison_operator       = var.comparison
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name[0]
  namespace                 = var.name_space
  period                    = var.scale_out_period
  statistic                 = "Average"
  threshold                 = var.scale_out_threshold
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []

  dimensions = {
    InstanceId = "${var.module_instance_id}"
  }
  alarm_actions = [var.module_scale_out_id]
  tags = merge(var.resource_owner, {
    Environment = var.environment == "production" ? "production" : "stage"


  }, )
}

#----------------------------------standart-Monitoring-Network--In-----------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "standart_monitoring_network_in" {
  count = var.create_resource["monitoring"] ? 1 : 0

  alarm_name          = "High-Network-In"
  comparison_operator = var.comparison
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name[1]
  namespace           = var.name_space
  period              = var.network_period
  statistic           = "Average"
  threshold           = var.network_threshold # Set your desired threshold in bytes
  alarm_description   = "Triggers if NetworkIn exceeds the threshold."

  dimensions = {
    InstanceId = "${var.module_instance_id}"
  }

  tags = merge(var.resource_owner, {
    Environment = var.environment == "production" ? "production" : "stage"


  }, )
}
#----------------------------------standart-Monitoring-Network--Out-----------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "standart_monitoring_network_out" {
  count = var.create_resource["monitoring"] ? 1 : 0

  alarm_name          = "High-Network-Out"
  comparison_operator = var.comparison
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name[2]
  namespace           = var.name_space
  period              = var.network_period
  statistic           = "Average"
  threshold           = var.network_threshold # Set your desired threshold in bytes
  alarm_description   = "Triggers if NetworkOut exceeds the threshold."

  dimensions = {
    InstanceId = "${var.module_instance_id}"
  }
  tags = merge(var.resource_owner, {
    Environment = var.environment == "production" ? "production" : "stage"


  }, )
}

#----------------------------------CloudWatch+SNS-----------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "Cloud_watch_and_sns" {
  count                     = var.create_resource["sns_topic"] ? 1 : 0
  alarm_name                = "standart-monitoring-cpu"
  comparison_operator       = var.comparison
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name[0]
  namespace                 = var.name_space
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

  tags = merge(var.resource_owner, {
    Environment = var.environment == "production" ? "production" : "stage"


  }, )
}