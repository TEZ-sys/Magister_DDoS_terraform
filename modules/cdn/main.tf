resource "aws_cloudfront_distribution" "my_distribution" {
  count   = var.create_resource["cdn"] ? 1 : 0
  aliases = [var.domain_name]
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
      query_string = var.cdn_boolean["query_string"]
      headers      = []
      cookies {
        forward = var.cdn_string_config["forward"]
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = var.cdn_string_config["restriction_type"]
    }
  }
  viewer_certificate {
    acm_certificate_arn            = var.cdn_certificate_arn
    ssl_support_method             = var.cdn_string_config["ssl_support_method"]
    minimum_protocol_version       = var.cdn_string_config["minimum_protocol_version"]
    cloudfront_default_certificate = var.cdn_boolean["cloudfront_default_certificate"]
  }

  enabled             = var.cdn_boolean["enabled"]
  is_ipv6_enabled     = var.cdn_boolean["is_ipv6_enabled"]
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
