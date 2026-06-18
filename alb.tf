module "alb" {
  # Local source for testing; change to registry for production:
  # source  = "thomasvjoseph/lb/aws"
  # version = "2.0.2"
  source = "../terraform-aws-lb"

  vpc_id       = module.vpc.vpc_id
  lb_resources = local.lb_resources
}