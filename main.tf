module "alb" {
  source = "../terraform-aws-lb"

  vpc_id       = module.vpc.vpc_id
  subnets      = module.vpc.private_subnets
  lb_resources = local.lb_resources
}

resource "aws_cloudfront_vpc_origin" "this" {
  for_each = local.cloudfront_resources

  vpc_origin_endpoint_config {
    name                   = each.value.vpc_origin_name
    arn                    = module.alb.alb_arn[each.key]
    http_port              = each.value.http_port
    https_port             = each.value.https_port
    origin_protocol_policy = each.value.origin_protocol_policy

    origin_ssl_protocols {
      items    = each.value.origin_ssl_protocols
      quantity = length(each.value.origin_ssl_protocols)
    }
  }

  tags = each.value.tags
}

resource "aws_cloudfront_distribution" "this" {
  for_each = local.cloudfront_resources

  origin {
    domain_name = module.alb.alb_dns_name[each.key]
    origin_id   = each.key

    vpc_origin_config {
      vpc_origin_id            = aws_cloudfront_vpc_origin.this[each.key].id
      origin_keepalive_timeout = each.value.origin_keepalive_timeout
      origin_read_timeout      = each.value.origin_read_timeout
    }
  }

  enabled             = each.value.enabled
  is_ipv6_enabled     = each.value.is_ipv6_enabled
  comment             = each.value.comment
  default_root_object = each.value.default_root_object
  aliases             = each.value.aliases
  price_class         = each.value.price_class

  default_cache_behavior {
    allowed_methods          = each.value.allowed_methods
    cached_methods           = each.value.cached_methods
    target_origin_id         = each.key
    viewer_protocol_policy   = each.value.viewer_protocol_policy
    compress                 = each.value.compress
    cache_policy_id          = each.value.cache_policy_id
    origin_request_policy_id = each.value.origin_request_policy_id
    min_ttl                  = each.value.min_ttl
    default_ttl              = each.value.default_ttl
    max_ttl                  = each.value.max_ttl

    dynamic "forwarded_values" {
      for_each = each.value.cache_policy_id == null ? [1] : []

      content {
        query_string = each.value.query_string
        headers      = each.value.headers

        cookies {
          forward = each.value.cookies_forward
        }
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = each.value.geo_restriction_type
      locations        = each.value.geo_restriction_locations
    }
  }

  dynamic "viewer_certificate" {
    for_each = length(each.value.aliases) > 0 && each.value.acm_certificate_arn != null ? [1] : []

    content {
      acm_certificate_arn      = each.value.acm_certificate_arn
      ssl_support_method       = "sni-only"
      minimum_protocol_version = "TLSv1.2_2021"
    }
  }

  dynamic "viewer_certificate" {
    for_each = length(each.value.aliases) == 0 || each.value.acm_certificate_arn == null ? [1] : []

    content {
      cloudfront_default_certificate = true
    }
  }

  tags = each.value.tags

  depends_on = [aws_cloudfront_vpc_origin.this]
}
