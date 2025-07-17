module "version_detection" {
  source = "./modules/version_detection"
  environment                = var.environment
  ver                       = var.ver
  alb_arn                   = module.alb.alb_arn
}

module "alb" {
  source                    = "./modules/alb"
  environment               = var.environment
  vpc_id                    = var.vpc_id
  public_subnet_ids         = var.public_subnet_ids
  domain_root               = var.domain_root
  route53_zone_id           = var.route53_zone_id
  route53_record_name       = var.route53_record_name
  canary_enabled            = var.canary_enabled
  canary_traffic_percentage = var.canary_traffic_percentage
}

module "production_asg" {
  source                   = "./modules/asg"
  environment              = var.environment
  ami_id                   = var.ami_id
  key_name                 = var.key_name
  instance_type            = var.instance_type
  vpc_id                   = var.vpc_id
  public_subnet_ids        = var.public_subnet_ids
  ver                      = var.canary_enabled ? module.version_detection.previous_production_version : var.ver
  desired_capacity         = var.production_desired_capacity
  target_group_arn         = module.alb.production_target_group_arn
  alb_sg_id                = module.alb.alb_sg_id
  s3_bucket                = aws_s3_bucket.artifacts.bucket
  instance_profile_name    = aws_iam_instance_profile.ec2_profile.name
  deployment_type          = "production"
}

module "canary_asg" {
  count = var.canary_enabled ? 1 : 0
  
  source                   = "./modules/asg"
  environment              = var.environment
  ami_id                   = var.ami_id
  key_name                 = var.key_name
  instance_type            = var.instance_type
  vpc_id                   = var.vpc_id
  public_subnet_ids        = var.public_subnet_ids
  ver                      = var.ver
  desired_capacity         = var.canary_desired_capacity
  target_group_arn         = module.alb.canary_target_group_arn
  alb_sg_id                = module.alb.alb_sg_id
  s3_bucket                = aws_s3_bucket.artifacts.bucket
  instance_profile_name    = aws_iam_instance_profile.ec2_profile.name
  deployment_type          = "canary"
}
