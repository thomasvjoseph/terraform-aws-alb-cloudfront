output "vpc_id" {
  description = "ID of the VPC."
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets."
  value       = module.vpc.private_subnets
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = module.vpc.public_subnets
}

output "alb_security_group_ids" {
  description = "Security group IDs created for the ALBs."
  value       = { for k, v in module.alb_security_group : k => v.security_group_id }
}

output "alb_dns_name" {
  description = "DNS names of the Application Load Balancers."
  value       = module.alb.alb_dns_name
}

output "alb_arn" {
  description = "ARNs of the Application Load Balancers."
  value       = module.alb.alb_arn
}

output "target_group_arn" {
  description = "ARNs of the ALB target groups."
  value       = module.alb.target_group_arn
}

output "vpc_origin_id" {
  description = "CloudFront VPC origin IDs."
  value       = { for k, v in aws_cloudfront_vpc_origin.this : k => v.id }
}

output "vpc_origin_arn" {
  description = "CloudFront VPC origin ARNs."
  value       = { for k, v in aws_cloudfront_vpc_origin.this : k => v.arn }
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution IDs."
  value       = { for k, v in aws_cloudfront_distribution.this : k => v.id }
}

output "cloudfront_distribution_arn" {
  description = "CloudFront distribution ARNs."
  value       = { for k, v in aws_cloudfront_distribution.this : k => v.arn }
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain names."
  value       = { for k, v in aws_cloudfront_distribution.this : k => v.domain_name }
}

output "cloudfront_hosted_zone_id" {
  description = "Route 53 hosted zone IDs for CloudFront distributions."
  value       = { for k, v in aws_cloudfront_distribution.this : k => v.hosted_zone_id }
}

output "ecs_security_group_ids" {
  description = "Security group IDs created for the ECS tasks."
  value       = { for k, v in module.ecs_security_group : k => v.security_group_id }
}

output "ecs_cluster_name" {
  description = "ECS cluster names."
  value       = module.ecs.ecs_cluster_name
}

output "ecs_service_name" {
  description = "ECS service names."
  value       = module.ecs.ecs_service_name
}

output "ecs_task_definition_arn" {
  description = "ARNs of the ECS task definitions."
  value       = module.ecs.ecs_task_definition_arn
}
