#----------------------------------------SNS-----------------------------------------
resource "aws_sns_topic" "my_alert_topic" {
  count = var.create_resource["sns_topic"] ? 1 : 0
  name  = "Nebo-alarm-topic"

  tags = merge(var.resource_owner, {
    Environment = var.environment


  }, )
}

resource "aws_sns_topic" "my_ok_topic" {
  count = var.create_resource["sns_topic"] ? 1 : 0
  name  = "Nebo-ok-topic"

  tags = merge(var.resource_owner, {
    Environment = var.environment


  }, )
}

#----------------------------------------Email-----------------------------------------
resource "aws_sns_topic_subscription" "email_alert" {
  count     = var.create_resource["sns_topic"] ? 1 : 0
  topic_arn = aws_sns_topic.my_alert_topic[0].arn
  protocol  = "email"
  endpoint  = var.email_address
}

resource "aws_sns_topic_subscription" "email_ok" {
  count     = var.create_resource["sns_topic"] ? 1 : 0
  topic_arn = aws_sns_topic.my_ok_topic[0].arn
  protocol  = "email"
  endpoint  = var.email_address
}