resource "aws_sns_topic" "my_topic" {
  count = var.create_resource["sns_topic"] ? 1 : 0
  name  = "Nebo-topic"

  tags = {
    Name        = "${var.resource_owner["name"]}-VPC"
    Owner       = var.resource_owner["owner"]
    Environment = var.resource_owner["Prod_Environment"]
  }
}


resource "aws_sns_topic_subscription" "email" {
  count     = var.create_resource["sns_topic"] ? 1 : 0
  topic_arn = aws_sns_topic.my_topic[0].arn
  protocol  = "email"
  endpoint  = var.email_address
}