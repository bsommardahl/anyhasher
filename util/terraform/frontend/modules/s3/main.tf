data "aws_iam_policy_document" "website_policy" {
  statement {
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["*"]
      type = "AWS"
    }
    resources = [
      "arn:aws:s3:::${var.bucket_name}/*"
    ]
  }
}

resource "aws_s3_bucket" "frontend" {
  bucket = var.bucket_name  
  force_destroy = true
  tags = {
    Environment = "Production"
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.frontend.id
  policy = data.aws_iam_policy_document.website_policy.json
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
