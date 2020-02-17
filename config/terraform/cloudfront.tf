locals {
  web_origin_id = "${aws_elb.WEB-ELB.name}"
}

resource "aws_cloudfront_distribution" "web-toptal" {
  origin {
    domain_name = "${aws_elb.WEB-ELB.dns_name}"
    origin_id   = "${local.web_origin_id}"
    custom_origin_config {
    http_port = 80
    https_port = 443
    origin_protocol_policy = "http-only"
    origin_keepalive_timeout = 60
    origin_ssl_protocols = ["SSLv3", "TLSv1", "TLSv1.1"]
    }
    }


  enabled             = true
  is_ipv6_enabled     = true
  comment             = "For Web CDN"

  logging_config {
    include_cookies = false
    bucket          = "${aws_s3_bucket.logs-toptal-test.bucket_domain_name}"
    prefix          = "cdn"
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.web_origin_id}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 3600
  }
 
 ordered_cache_behavior {
    path_pattern     = "/images/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "${local.web_origin_id}"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "allow-all"
  }
 restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
