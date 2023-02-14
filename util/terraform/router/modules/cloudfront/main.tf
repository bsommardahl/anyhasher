resource "aws_cloudfront_distribution" "production_distribution" {
  
  origin {
    domain_name = var.frontend_url
    origin_id   = "primaryS3"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

variable "frontend_url" {
  description = "Bucket URL for production version"
}