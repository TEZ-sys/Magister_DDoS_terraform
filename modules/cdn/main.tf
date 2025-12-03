resource "aws_cloudfront_distribution" "my_distribution" {
  count = var.create_resource["cdn"] ? 1 : 0
  origin {
    domain_name = var.cdn_s3_link
    origin_id   = var.cdn_s3_origin
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.my_oai[count.index].cloudfront_access_identity_path
    }
  }
  default_cache_behavior {
    target_origin_id       = var.cdn_s3_origin
    viewer_protocol_policy = var.cdn_viewer_protocol_policy
    allowed_methods        = var.cdn_allowed_methods
    cached_methods         = var.cdn_cached_methods
    min_ttl                = var.cdn_ttl["min"]
    default_ttl            = var.cdn_ttl["default"]
    max_ttl                = var.cdn_ttl["max"]
    forwarded_values {
      query_string = false
      headers      = ["*"]
      cookies {
        forward = "all"
      }
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = var.index_document

  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}

resource "aws_cloudfront_origin_access_identity" "my_oai" {
  count   = var.create_resource["cdn"] ? 1 : 0
  comment = "CloudFront OAI for S3 bucket"
}
