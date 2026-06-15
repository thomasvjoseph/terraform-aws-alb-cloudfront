variable "name" {
  description = "Name prefix for the VPC and related resources."
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones for VPC subnets."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks for the internal ALB."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks. Internet gateway attaches here (required for VPC origins)."
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Create NAT gateway(s) for private subnet egress."
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Use a single NAT gateway for all private subnets."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}

variable "lb_resources" {
  description = "Load balancer definitions passed to the ALB module. Keys must match cloudfront_resources."
  type = map(object({
    lb_name                    = string
    lb_target_type             = string
    internal                   = optional(bool, true)
    tg_name                    = string
    tg_port_number             = number
    lb_port_number             = number
    lb_target_id               = list(string)
    load_balancer_type         = string
    enable_deletion_protection = bool
    tags                       = map(string)
    use_for                    = string
  }))
}

variable "cloudfront_resources" {
  description = "CloudFront VPC origin and distribution settings. Keys must match lb_resources."
  type = map(object({
    vpc_origin_name           = string
    http_port                 = optional(number)
    https_port                = optional(number)
    origin_protocol_policy    = optional(string, "https-only")
    origin_ssl_protocols      = optional(list(string), ["TLSv1.2"])
    origin_keepalive_timeout  = optional(number, 5)
    origin_read_timeout       = optional(number, 30)
    enabled                   = optional(bool, true)
    is_ipv6_enabled           = optional(bool, true)
    comment                   = optional(string, "")
    default_root_object       = optional(string)
    aliases                   = optional(list(string), [])
    price_class               = optional(string, "PriceClass_100")
    allowed_methods           = optional(list(string), ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"])
    cached_methods            = optional(list(string), ["GET", "HEAD"])
    viewer_protocol_policy    = optional(string, "redirect-to-https")
    compress                  = optional(bool, true)
    cache_policy_id           = optional(string)
    origin_request_policy_id  = optional(string)
    query_string              = optional(bool, false)
    headers                   = optional(list(string), [])
    cookies_forward           = optional(string, "none")
    min_ttl                   = optional(number, 0)
    default_ttl               = optional(number, 0)
    max_ttl                   = optional(number, 0)
    geo_restriction_type      = optional(string, "none")
    geo_restriction_locations = optional(list(string), [])
    acm_certificate_arn       = optional(string)
    tags                      = optional(map(string), {})
  }))
}
