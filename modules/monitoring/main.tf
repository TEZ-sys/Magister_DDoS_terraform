#----------------------------------Defence-Monitoring-CPU-Scale-In-----------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "defenders_monitoring_cpu_scale_in" {
  alarm_name                = "defenders-monitoring-cpu"
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
}

#----------------------------------Defence-Monitoring-CPU-Scale-Out-----------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "defenders_monitoring_cpu_scale_out" {
  alarm_name                = "defenders-monitoring-cpu"
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
}

#----------------------------------Defence-Monitoring-Network--In-----------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "defenders_monitoring_network_in" {
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
}
#----------------------------------Defence-Monitoring-Network--Out-----------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "defenders_monitoring_network_out" {
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
}