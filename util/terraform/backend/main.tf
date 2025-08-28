module "version_detection" {
  source      = "./modules/version_detection"
  environment = var.environment
}

module "bluegreen_alb" {
  source              = "./modules/alb"
  environment         = var.environment
  vpc_id              = var.vpc_id
  public_subnet_ids   = var.public_subnet_ids
  domain_root         = var.domain_root
  route53_zone_id     = var.route53_zone_id
  route53_record_name = var.route53_record_name
  use_green_environment  = var.use_green_environment
}

module "blue_asg" {
  source                = "./modules/asg"
  environment           = var.environment
  deployment_color      = "blue"
  ami_id                = var.ami_id
  key_name              = var.key_name
  instance_type         = var.instance_type
  vpc_id                = var.vpc_id
  public_subnet_ids     = var.public_subnet_ids
  ver                   = var.blue_version != null ? var.blue_version : module.version_detection.previous_blue_version
  desired_capacity      = var.blue_desired_capacity != null ? var.blue_desired_capacity : module.version_detection.previous_blue_desired_capacity
  target_group_arn      = module.bluegreen_alb.blue_target_group_arn
  alb_sg_id             = module.bluegreen_alb.alb_sg_id
  s3_bucket             = aws_s3_bucket.artifacts.bucket
  instance_profile_name = aws_iam_instance_profile.ec2_profile.name
}

module "green_asg" {
  count = var.use_green_environment ? 1 : 0

  source                = "./modules/asg"
  environment           = var.environment
  deployment_color      = "green"
  ami_id                = var.ami_id
  key_name              = var.key_name
  instance_type         = var.instance_type
  vpc_id                = var.vpc_id
  public_subnet_ids     = var.public_subnet_ids
  ver                   = var.green_version != null ? var.green_version : module.version_detection.previous_green_version
  desired_capacity      = var.green_desired_capacity != null ? var.green_desired_capacity : module.version_detection.previous_green_desired_capacity
  target_group_arn      = module.bluegreen_alb.green_target_group_arn
  alb_sg_id             = module.bluegreen_alb.alb_sg_id
  s3_bucket             = aws_s3_bucket.artifacts.bucket
  instance_profile_name = aws_iam_instance_profile.ec2_profile.name
}

