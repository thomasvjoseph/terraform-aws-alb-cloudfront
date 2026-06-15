# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-06-15

### Added

- Initial Terraform module for CloudFront VPC origins with a private internal ALB.
- VPC creation via [terraform-aws-modules/vpc](https://github.com/terraform-aws-modules/terraform-aws-vpc).
- ALB security groups via [terraform-aws-modules/security-group](https://github.com/terraform-aws-modules/terraform-aws-security-group), with ingress from the CloudFront managed prefix list `com.amazonaws.global.cloudfront.origin-facing`.
- Application Load Balancer provisioning via the custom [`terraform-aws-lb`](../terraform-aws-lb) module.
- `aws_cloudfront_vpc_origin` resources for private ALB origins.
- `aws_cloudfront_distribution` resources configured with `vpc_origin_config`.
- Module files: `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `vpc.tf`, `security_groups.tf`, and `locals.tf`.
- Inputs for VPC layout (`name`, `vpc_cidr`, `azs`, `private_subnet_cidrs`, `public_subnet_cidrs`, NAT options, and tags).
- Map-based `lb_resources` and `cloudfront_resources` inputs for multi-service deployments.
- Outputs for VPC, security groups, ALB, VPC origins, and CloudFront distributions.
- Provider requirements: Terraform `>= 1.3`, AWS provider `>= 6.20.0`.

[1.0.0]: https://github.com/thomasvjoseph/terraform-alb-cloudfront/releases/tag/v1.0.0
