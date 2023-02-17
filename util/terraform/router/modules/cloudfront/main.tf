resource "aws_cloudfront_distribution" "production_distribution" {
  
  origin {
    domain_name = var.s3_bucket_hostname
    origin_id = var.origin_id

    custom_origin_config {
      http_port = "80"
      https_port = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled = true
  default_root_object = "index.html"

  default_cache_behavior {
    #viewer_protocol_policy = "redirect-to-https"
    viewer_protocol_policy = "allow-all"
    compress = true
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = var.origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
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
    ssl_support_method = "sni-only"
  }
}

variable "s3_bucket_hostname" {
  description = "specifies the DNS domain name of the origin"
}

variable "origin_id" {
  description = "specifies a unique identifier for the origin"
}

output domain_name {
  value = aws_cloudfront_distribution.production_distribution.domain_name
}
