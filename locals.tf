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

  lb_resources = {
    for key, lb in var.lb_resources : key => merge(lb, {
      lb_security_group = [module.alb_security_group[key].security_group_id]
      internal          = coalesce(lb.internal, true)
    })
  }
}
