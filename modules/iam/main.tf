resource "aws_iam_role" "monitoring_role" {
  count = var.create_resource["iam_role"] ? 1 : 0
  name  = "ec2_monitoring_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}

resource "aws_iam_policy" "cw_put_metric" {
  count       = var.create_resource["iam_role"] ? 1 : 0
  name        = "cw_put_metric"
  description = "Allow EC2 to push metrics to CloudWatch"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "cloudwatch:PutMetricData",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams",
        "logs:DescribeLogGroups",
        "logs:FilterLogEvents",
        "logs:GetLogEvents"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_iam_policy" "cw_put_logs" {
  count       = var.create_resource["logging"] ? 1 : 0
  name        = "cw_put_logs"
  description = "Allow EC2 to push logs to CloudWatch logs"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups",
          "logs:FilterLogEvents",
          "logs:GetLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cw_attach" {
  count      = var.create_resource["iam_role"] ? 1 : 0
  role       = aws_iam_role.monitoring_role[count.index].name
  policy_arn = aws_iam_policy.cw_put_metric[count.index].arn
}

resource "aws_iam_role_policy_attachment" "cw_logs_attach" {
  count      = var.create_resource["logging"] ? 1 : 0
  role       = aws_iam_role.monitoring_role[count.index].name
  policy_arn = aws_iam_policy.cw_put_logs[count.index].arn
}

resource "aws_iam_instance_profile" "monitoring_profile" {
  count = var.create_resource["iam_role"] ? 1 : 0
  name  = "monitoring_profile"
  role  = aws_iam_role.monitoring_role[count.index].name
}