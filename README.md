# terraform-alb-cloudfront

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.20.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.51.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | ../terraform-aws-lb | n/a |
| <a name="module_alb_security_group"></a> [alb\_security\_group](#module\_alb\_security\_group) | terraform-aws-modules/security-group/aws | ~> 5.0 |
| <a name="module_ecs"></a> [ecs](#module\_ecs) | ../terraform-aws-ecs | n/a |
| <a name="module_ecs_security_group"></a> [ecs\_security\_group](#module\_ecs\_security\_group) | terraform-aws-modules/security-group/aws | ~> 5.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_vpc_origin.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_vpc_origin) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azs"></a> [azs](#input\_azs) | Availability zones for VPC subnets. | `list(string)` | n/a | yes |
| <a name="input_cloudfront_resources"></a> [cloudfront\_resources](#input\_cloudfront\_resources) | CloudFront VPC origin and distribution settings. Keys must match lb\_resources. | <pre>map(object({<br/>    vpc_origin_name           = string<br/>    http_port                 = optional(number)<br/>    https_port                = optional(number)<br/>    origin_protocol_policy    = optional(string, "https-only")<br/>    origin_ssl_protocols      = optional(list(string), ["TLSv1.2"])<br/>    origin_keepalive_timeout  = optional(number, 5)<br/>    origin_read_timeout       = optional(number, 30)<br/>    enabled                   = optional(bool, true)<br/>    is_ipv6_enabled           = optional(bool, true)<br/>    comment                   = optional(string, "")<br/>    default_root_object       = optional(string)<br/>    aliases                   = optional(list(string), [])<br/>    price_class               = optional(string, "PriceClass_100")<br/>    allowed_methods           = optional(list(string), ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"])<br/>    cached_methods            = optional(list(string), ["GET", "HEAD"])<br/>    viewer_protocol_policy    = optional(string, "redirect-to-https")<br/>    compress                  = optional(bool, true)<br/>    cache_policy_id           = optional(string)<br/>    origin_request_policy_id  = optional(string)<br/>    query_string              = optional(bool, false)<br/>    headers                   = optional(list(string), [])<br/>    cookies_forward           = optional(string, "none")<br/>    min_ttl                   = optional(number, 0)<br/>    default_ttl               = optional(number, 0)<br/>    max_ttl                   = optional(number, 0)<br/>    geo_restriction_type      = optional(string, "none")<br/>    geo_restriction_locations = optional(list(string), [])<br/>    acm_certificate_arn       = optional(string)<br/>    tags                      = optional(map(string), {})<br/>  }))</pre> | n/a | yes |
| <a name="input_ecs_resources"></a> [ecs\_resources](#input\_ecs\_resources) | ECS service definitions. Keys must match lb\_resources. Security groups, target group ARNs, and subnets are managed internally. | <pre>map(object({<br/>    ecs_cluster_name                  = string<br/>    ecs_task_def_family               = string<br/>    ecs_task_def_network_mode         = string<br/>    ecs_task_requires_compatibilities = list(string)<br/>    ecs_os_family                     = optional(string, "LINUX")<br/>    ecs_cpu_architecture              = optional(string, "X86_64")<br/>    ecs_task_def_cpu                  = number<br/>    ecs_task_def_memory               = number<br/>    ecs_task_def_task_role_arn        = optional(string, null)<br/>    ecs_task_def_execution_role_arn   = string<br/>    ecs_task_def_container_name       = string<br/>    ecs_image_url                     = string<br/>    ecs_container_cpu                 = optional(number, null)<br/>    ecs_container_memory_reservation  = optional(number, null)<br/>    ecs_task_def_container_port       = optional(number, null)<br/>    ecs_task_def_host_port            = optional(number, null)<br/>    ecs_awslogs_group                 = string<br/>    aws_region                        = string<br/>    ecs_service_name                  = string<br/>    ecs_launch_type                   = string<br/>    ecs_service_container_name        = string<br/>    ecs_service_container_port        = number<br/>    desired_count                     = optional(number, 1)<br/>    enable_autoscaling                = optional(bool, false)<br/>    enable_cpu_autoscaling            = optional(bool, false)<br/>    enable_memory_autoscaling         = optional(bool, false)<br/>    asg_max_size                      = optional(number, 2)<br/>    asg_min_size                      = optional(number, 1)<br/>    cpu_target_value                  = optional(number, 70)<br/>    memory_target_value               = optional(number, 85)<br/>    tags                              = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Create NAT gateway(s) for private subnet egress. | `bool` | `false` | no |
| <a name="input_lb_resources"></a> [lb\_resources](#input\_lb\_resources) | Load balancer definitions passed to the ALB module. Keys must match cloudfront\_resources. | <pre>map(object({<br/>    lb_name                    = string<br/>    lb_target_type             = string<br/>    internal                   = optional(bool, true)<br/>    tg_name                    = string<br/>    tg_port_number             = number<br/>    lb_port_number             = number<br/>    lb_target_id               = list(string)<br/>    load_balancer_type         = string<br/>    enable_deletion_protection = bool<br/>    tags                       = map(string)<br/>    use_for                    = string<br/>  }))</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name prefix for the VPC and related resources. | `string` | n/a | yes |
| <a name="input_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#input\_private\_subnet\_cidrs) | Private subnet CIDR blocks for the internal ALB. | `list(string)` | n/a | yes |
| <a name="input_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#input\_public\_subnet\_cidrs) | Public subnet CIDR blocks. Internet gateway attaches here (required for VPC origins). | `list(string)` | n/a | yes |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Use a single NAT gateway for all private subnets. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources. | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | IPv4 CIDR block for the VPC. | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | ARNs of the Application Load Balancers. |
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | DNS names of the Application Load Balancers. |
| <a name="output_alb_security_group_ids"></a> [alb\_security\_group\_ids](#output\_alb\_security\_group\_ids) | Security group IDs created for the ALBs. |
| <a name="output_cloudfront_distribution_arn"></a> [cloudfront\_distribution\_arn](#output\_cloudfront\_distribution\_arn) | CloudFront distribution ARNs. |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | CloudFront distribution IDs. |
| <a name="output_cloudfront_domain_name"></a> [cloudfront\_domain\_name](#output\_cloudfront\_domain\_name) | CloudFront distribution domain names. |
| <a name="output_cloudfront_hosted_zone_id"></a> [cloudfront\_hosted\_zone\_id](#output\_cloudfront\_hosted\_zone\_id) | Route 53 hosted zone IDs for CloudFront distributions. |
| <a name="output_ecs_cluster_name"></a> [ecs\_cluster\_name](#output\_ecs\_cluster\_name) | ECS cluster names. |
| <a name="output_ecs_security_group_ids"></a> [ecs\_security\_group\_ids](#output\_ecs\_security\_group\_ids) | Security group IDs created for the ECS tasks. |
| <a name="output_ecs_service_name"></a> [ecs\_service\_name](#output\_ecs\_service\_name) | ECS service names. |
| <a name="output_ecs_task_definition_arn"></a> [ecs\_task\_definition\_arn](#output\_ecs\_task\_definition\_arn) | ARNs of the ECS task definitions. |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | IDs of the private subnets. |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | IDs of the public subnets. |
| <a name="output_target_group_arn"></a> [target\_group\_arn](#output\_target\_group\_arn) | ARNs of the ALB target groups. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of the VPC. |
| <a name="output_vpc_origin_arn"></a> [vpc\_origin\_arn](#output\_vpc\_origin\_arn) | CloudFront VPC origin ARNs. |
| <a name="output_vpc_origin_id"></a> [vpc\_origin\_id](#output\_vpc\_origin\_id) | CloudFront VPC origin IDs. |
<!-- END_TF_DOCS -->
