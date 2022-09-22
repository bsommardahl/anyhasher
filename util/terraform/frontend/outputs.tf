output "ec2_public_ip" {
  value = module.ec2.ec2_public_ip
}

output "website_endpoint" {
  value = module.s3.website_endpoint
}

output "bucket_name" {
  value = module.s3.bucket_name
}
