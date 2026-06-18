module "ecs_security_group" {
  for_each = var.ecs_resources

  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${each.value.ecs_service_name}-sg"
  description = "Allow ALB traffic to ${each.value.ecs_service_name} ECS tasks"
  vpc_id      = module.vpc.vpc_id

  # Allow inbound from the corresponding ALB security group on the container port.
  # Keys in ecs_resources must match keys in lb_resources.
  computed_ingress_with_source_security_group_id = [
    {
      from_port                = each.value.ecs_service_container_port
      to_port                  = each.value.ecs_service_container_port
      protocol                 = "tcp"
      description              = "ALB to ECS task"
      source_security_group_id = module.alb_security_group[each.key].security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules = ["all-all"]
  tags         = merge(var.tags, each.value.tags)
}

module "ecs" {
  source = "../terraform-aws-ecs"

  ecs_resources = local.ecs_resources
  tags          = var.tags
}
