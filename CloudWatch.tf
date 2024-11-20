resource "aws_cloudwatch_metric_alarm" "defenders_monitoring_cpu_scale_in" {
  alarm_name                = "defenders-monitoring-cpu"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 10
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []

  dimensions = {
    InstanceId = aws_instance.defender_instance.id
  }
  alarm_actions = [aws_autoscaling_policy.scale_in.arn]
}

resource "aws_cloudwatch_metric_alarm" "defenders_monitoring_cpu_scale_out" {
  alarm_name                = "defenders-monitoring-cpu"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 20
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []

  dimensions = {
    InstanceId = aws_instance.defender_instance.id
  }
  alarm_actions = [aws_autoscaling_policy.scale_out.arn]
}

resource "aws_cloudwatch_metric_alarm" "defenders_monitoring_network_in" {
  alarm_name          = "High-Network-In"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "NetworkIn"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 2000000 # Set your desired threshold in bytes
  alarm_description   = "Triggers if NetworkIn exceeds the threshold."
  dimensions = {
    InstanceId = aws_instance.defender_instance.id
  }
}

resource "aws_cloudwatch_metric_alarm" "defenders_monitoring_network_out" {
  alarm_name          = "High-Network-Out"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "NetworkOut"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 2000000 # Set your desired threshold in bytes
  alarm_description   = "Triggers if NetworkOut exceeds the threshold."
  dimensions = {
    InstanceId = aws_instance.defender_instance.id
  }
}


#
#resource "aws_cloudwatch_metric_alarm" "sub_defenders_monitoring_cpu" {
#  alarm_name                = "sub_defenders-monitoring-cpu"
#  comparison_operator       = "GreaterThanOrEqualToThreshold"
#  evaluation_periods        = 1
#  metric_name               = "CPUUtilization"
#  namespace                 = "AWS/EC2"
#  period                    = 300
#  statistic                 = "Average"
#  threshold                 = 20
#  alarm_description         = "This metric monitors ec2 cpu utilization"
#  insufficient_data_actions = []
#
#  dimensions = {
#    InstanceId = aws_instance.sub_defender_instance.id
#  }
#}
#
#resource "aws_cloudwatch_metric_alarm" "sub_defenders_monitoring_network_in" {
#  alarm_name          = "sub_High-Network-In"
#  comparison_operator = "GreaterThanOrEqualToThreshold"
#  evaluation_periods  = 1
#  metric_name         = "NetworkIn"
#  namespace           = "AWS/EC2"
#  period              = 300
#  statistic           = "Average"
#  threshold           = 2000000 # Set your desired threshold in bytes
#  alarm_description   = "Triggers if NetworkIn exceeds the threshold."
#  dimensions = {
#    InstanceId = aws_instance.sub_defender_instance.id
#  }
#}
#
#resource "aws_cloudwatch_metric_alarm" "sub_defenders_monitoring_network_out" {
#  alarm_name          = "sub_High-Network-Out"
#  comparison_operator = "GreaterThanOrEqualToThreshold"
#  evaluation_periods  = 1
#  metric_name         = "NetworkOut"
#  namespace           = "AWS/EC2"
#  period              = 300
#  statistic           = "Average"
#  threshold           = 2000000 # Set your desired threshold in bytes
#  alarm_description   = "Triggers if NetworkOut exceeds the threshold."
#  dimensions = {
#    InstanceId = aws_instance.sub_defender_instance.id
#  }
#}