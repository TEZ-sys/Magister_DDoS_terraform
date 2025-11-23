#----------------------------------------SNS-----------------------------------------
resource "aws_sns_topic" "my_alert_topic" {
  count = var.create_resource["sns_topic"] ? 1 : 0
  name  = "Nebo-alarm-topic"

  tags = {
    Name        = "${var.resource_owner["name"]}-SNS-Alert-Topic"
    Owner       = var.resource_owner["owner"]
    Environment = var.resource_owner["Prod_Environment"]
  }
}

resource "aws_sns_topic" "my_ok_topic" {
  count = var.create_resource["sns_topic"] ? 1 : 0
  name  = "Nebo-ok-topic"

  tags = {
    Name        = "${var.resource_owner["name"]}-SNS-Ok-Topic"
    Owner       = var.resource_owner["owner"]
    Environment = var.resource_owner["Prod_Environment"]
  }
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