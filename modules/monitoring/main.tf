#----------------------------------standart-Monitoring-CPU-Scale-In-----------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "monitoring_cpu_scale_in" {
  count                     = var.create_resource["monitoring"] ? 1 : 0
  alarm_name                = "standart-monitoring-cpu"
  comparison_operator       = var.comparison
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name["cpu"]
  namespace                 = var.name_space["ec2"]
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
    Environment = var.environment


  }, )
}

#----------------------------------standart-Monitoring-CPU-Scale-Out-----------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "monitoring_cpu_scale_out" {
  count = var.create_resource["monitoring"] ? 1 : 0

  alarm_name                = "standart-monitoring-cpu"
  comparison_operator       = var.comparison
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name["cpu"]
  namespace                 = var.name_space["ec2"]
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
    Environment = var.environment


  }, )
}

#----------------------------------standart-Monitoring-Network--In-----------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "monitoring_custom_metric" {
  count = var.create_resource["monitoring"] ? 1 : 0

  alarm_name          = "High-Custom-Metric"
  comparison_operator = var.comparison
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name["custom"]
  namespace           = var.name_space["custom"]
  period              = var.network_period
  statistic           = "Average"
  threshold           = var.network_threshold
  alarm_description   = "Triggers if Custom metric exceeds the threshold."

  dimensions = {
    InstanceId = "${var.module_instance_id}"
  }

  tags = merge(var.resource_owner, {
    Environment = var.environment


  }, )
}
#----------------------------------standart-Monitoring-Network--Out-----------------------------------------------------
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
  tags = merge(var.resource_owner, {
    Environment = var.environment


  }, )
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

  tags = merge(var.resource_owner, {
    Environment = var.environment


  }, )
}