module "alb" {
  source              = "./modules/alb"
  environment         = var.environment
  vpc_id              = var.vpc_id
  public_subnet_ids   = var.public_subnet_ids
  domain_root         = var.domain_root
  route53_zone_id     = var.route53_zone_id
  route53_record_name = var.route53_record_name
}

module "asg" {
  source                   = "./modules/asg"
  environment              = var.environment
  ami_id                   = var.ami_id
  key_name                 = var.key_name
  instance_type            = var.instance_type
  vpc_id                   = var.vpc_id
  public_subnet_ids        = var.public_subnet_ids
  ver                      = var.ver
  desired_capacity         = var.desired_capacity
  target_group_arn         = module.alb.target_group_arn
  alb_sg_id                = module.alb.alb_sg_id
  rollout_duration_seconds = var.rollout_duration_seconds
  s3_bucket               = aws_s3_bucket.artifacts.bucket
  instance_profile_name   = aws_iam_instance_profile.ec2_profile.name
  checkpoint_wait         = var.checkpoint_wait
  min_healthy_percentage  = var.min_healthy_percentage
}
