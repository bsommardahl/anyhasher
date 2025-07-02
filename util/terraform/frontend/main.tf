module "s3" {
  source          = "./modules/s3"
  environment     = var.environment
  ver             = var.ver
  route53_zone_id = var.route53_zone_id
}

