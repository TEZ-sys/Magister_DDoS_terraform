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
resource "aws_iam_role" "ec2_mysql" {
  count       = var.create_resource["iam_role_custom"] ? 1 : 0
  name        = "nebo-db-ec2-role"
  description = "Allows EC2 instances to read MySQL credentials from Secrets Manager"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role[count.index].json

}

data "aws_iam_policy_document" "ec2_assume_role" {
  count = var.create_resource["iam_role_custom"] ? 1 : 0
  statement {
    sid     = "AllowEC2AssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "secrets_manager_read" {
  count       = var.create_resource["iam_role_custom"] ? 1 : 0
  name        = "nebo-db-secrets-read"
  description = "Grants read-only access to the MySQL credentials secret"

  policy = data.aws_iam_policy_document.secrets_manager_read[count.index].json
}

data "aws_iam_policy_document" "secrets_manager_read" {
  count = var.create_resource["iam_role_custom"] ? 1 : 0
  statement {
    sid    = "GetSecretValue"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
    ]
    resources = [var.secrets_arn]
  }

  statement {
    sid    = "DecryptSecretKMS"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["secretsmanager.${var.region}.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "secrets_manager_read" {
  count      = var.create_resource["iam_role_custom"] ? 1 : 0
  role       = aws_iam_role.ec2_mysql[count.index].name
  policy_arn = aws_iam_policy.secrets_manager_read[count.index].arn
}
resource "aws_iam_instance_profile" "ec2_mysql_profile" {
  count = var.create_resource["iam_role_custom"] ? 1 : 0
  name  = "nebo-db-ec2-profile"
  role  = aws_iam_role.ec2_mysql[count.index].name
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