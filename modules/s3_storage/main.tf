resource "aws_s3_bucket" "nebo_bucket" {
  count  = var.create_resource["s3_storage"] ? 1 : 0
  bucket = var.bucket_name

  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}

resource "aws_s3_bucket_acl" "nebo_bucket_acl" {
  count  = var.create_resource["s3_storage"] ? 1 : 0
  bucket = aws_s3_bucket.nebo_bucket[0].id
  acl    = var.bucket_acl
}

resource "aws_s3_bucket_website_configuration" "nebo_bucket_website" {
  count  = var.create_resource["s3_storage"] ? 1 : 0
  bucket = aws_s3_bucket.nebo_bucket[0].id

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }
}

resource "aws_s3_bucket_policy" "cloudfront_access" {
  count  = var.create_resource["s3_storage"] ? 1 : 0
  bucket = aws_s3_bucket.nebo_bucket[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontOAI"
        Effect = "Allow"
        Principal = {
          AWS = "${var.cloudfront_oai}"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.nebo_bucket[0].arn}/*"
      }
    ]
  })
}

resource "aws_s3_object" "index_html" {
  count        = var.create_resource["s3_storage"] ? 1 : 0
  bucket       = aws_s3_bucket.nebo_bucket[0].id
  key          = var.index_document
  source       = "${path.root}/scripts/index.html"
  content_type = var.content_type
  etag         = filemd5("${path.root}/scripts/index.html")
}

resource "aws_s3_object" "error_html" {
  count        = var.create_resource["s3_storage"] ? 1 : 0
  bucket       = aws_s3_bucket.nebo_bucket[0].id
  key          = var.error_document
  source       = "${path.root}/scripts/error.html"
  content_type = var.content_type
  etag         = filemd5("${path.root}/scripts/error.html")
}