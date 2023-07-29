resource "aws_cloudfront_distribution" "cloudfront" {
  comment         = "My CloudFront distribution"
  enabled         = true
#   is_ipv6_enabled = true

  origin {
    domain_name = aws_lb.load_balancer.dns_name
    origin_id   = "my-alb-origin-terraform"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  default_root_object = "tasks"
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "my-alb-origin-terraform"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"  
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = "my-cloudfront-distribution"
  }
}
