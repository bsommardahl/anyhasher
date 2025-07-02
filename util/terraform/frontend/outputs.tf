output "bucket_name" {
  value = module.s3.bucket_name
}

output "website_endpoint" {
  description = "Frontend URL"
  value       = "http://app.anyhasher.io"
}
