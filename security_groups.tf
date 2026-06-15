data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

module "alb_security_group" {
  for_each = var.lb_resources

  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${each.value.lb_name}-sg"
  description = "Allow CloudFront VPC origin traffic to ${each.value.lb_name}"
  vpc_id      = module.vpc.vpc_id

  ingress_prefix_list_ids = [data.aws_ec2_managed_prefix_list.cloudfront.id]

  ingress_with_prefix_list_ids = [
    for port in local.alb_ingress_ports[each.key] : {
      from_port   = tostring(port)
      to_port     = tostring(port)
      protocol    = "tcp"
      description = "CloudFront VPC origin"
    }
  ]

  egress_rules = ["all-all"]
  tags         = merge(var.tags, each.value.tags)
}
