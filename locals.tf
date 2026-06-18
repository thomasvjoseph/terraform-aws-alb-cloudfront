locals {
  cloudfront_resources = {
    for key, cf in var.cloudfront_resources : key => merge(
      cf,
      {
        http_port  = coalesce(cf.http_port, var.lb_resources[key].lb_port_number)
        https_port = coalesce(cf.https_port, var.lb_resources[key].lb_port_number)
        tags       = merge(var.tags, var.lb_resources[key].tags, cf.tags)
      }
    )
  }

  alb_ingress_ports = {
    for key, cf in local.cloudfront_resources : key => (
      cf.origin_protocol_policy == "http-only" ? [cf.http_port] :
      cf.origin_protocol_policy == "https-only" ? [cf.https_port] :
      distinct([cf.http_port, cf.https_port])
    )
  }

  ecs_resources = {
    for key, ecs in var.ecs_resources : key => merge(ecs, {
      ecs_security_group   = [module.ecs_security_group[key].security_group_id]
      ecs_target_group_arn = module.alb.target_group_arn[key]
      subnet_ids           = module.vpc.private_subnets
      assign_public_ip     = false
    })
  }

  lb_resources = {
    for key, lb in var.lb_resources : key => merge(lb, {
      lb_security_group = [module.alb_security_group[key].security_group_id]
      internal          = coalesce(lb.internal, true)
      subnets           = coalesce(lb.internal, true) ? module.vpc.private_subnets : module.vpc.public_subnets
    })
  }
}
