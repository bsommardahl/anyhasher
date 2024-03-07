resource "aws_s3_bucket" "frontend" {
  bucket = var.bucket_name
  force_destroy = true
  tags = {
    Environment = "Production"
  }
}

resource "aws_s3_bucket_cors_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id  

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }  
}

resource "aws_s3_bucket_acl" "frontend" {
    bucket = aws_s3_bucket.frontend.id
    acl    = "public-read"
    depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.frontend.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.frontend]
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "bucket_name" {
    bucket = aws_s3_bucket.frontend.id
    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Principal = "*"
        Action = [
          "s3:*",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      },
      {
        Sid = "PublicReadGetObject"
        Principal = "*"
        Action = [
          "s3:GetObject",
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      },
    ]
  })
  
  depends_on = [aws_s3_bucket_public_access_block.frontend]
}

resource "aws_s3_bucket_website_configuration" "frontend_configuration" {
  bucket = aws_s3_bucket.frontend.id
  
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

variable "bucket_name" {
  description = "Website bucket name"
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.frontend_configuration.website_endpoint
}

output "bucket_name" {
  value = aws_s3_bucket.frontend.id
}