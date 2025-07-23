module "bluegreen_alb" {
  source              = "./modules/alb"
  environment         = var.environment
  vpc_id              = var.vpc_id
  public_subnet_ids   = var.public_subnet_ids
  domain_root         = var.domain_root
  route53_zone_id     = var.route53_zone_id
  route53_record_name = var.route53_record_name
  active_environment  = var.active_environment
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
  ver                   = var.blue_version
  desired_capacity      = var.desired_capacity
  target_group_arn      = module.bluegreen_alb.blue_target_group_arn
  alb_sg_id             = module.bluegreen_alb.alb_sg_id
  s3_bucket             = aws_s3_bucket.artifacts.bucket
  instance_profile_name = aws_iam_instance_profile.ec2_profile.name
}

module "green_asg" {
  source                = "./modules/asg"
  environment           = var.environment
  deployment_color      = "green"
  ami_id                = var.ami_id
  key_name              = var.key_name
  instance_type         = var.instance_type
  vpc_id                = var.vpc_id
  public_subnet_ids     = var.public_subnet_ids
  ver                   = var.green_version
  desired_capacity      = var.desired_capacity
  target_group_arn      = module.bluegreen_alb.green_target_group_arn
  alb_sg_id             = module.bluegreen_alb.alb_sg_id
  s3_bucket             = aws_s3_bucket.artifacts.bucket
  instance_profile_name = aws_iam_instance_profile.ec2_profile.name
}

