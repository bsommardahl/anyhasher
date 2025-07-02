module "s3" {
  source      = "./modules/s3"
  environment = var.environment
  ver         = var.ver
}

