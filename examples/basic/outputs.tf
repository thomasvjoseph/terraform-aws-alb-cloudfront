output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name."
  value       = module.alb_cloudfront.cloudfront_domain_name
}

output "alb_dns_name" {
  description = "Internal ALB DNS name."
  value       = module.alb_cloudfront.alb_dns_name
}

output "vpc_id" {
  description = "VPC ID."
  value       = module.alb_cloudfront.vpc_id
}

output "ecs_cluster_name" {
  description = "ECS cluster name."
  value       = module.alb_cloudfront.ecs_cluster_name
}
