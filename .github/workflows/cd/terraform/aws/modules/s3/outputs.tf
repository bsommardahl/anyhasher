output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.frontend_configuration.website_endpoint
}

output "bucket_name" {
  value = aws_s3_bucket.frontend.id
}
