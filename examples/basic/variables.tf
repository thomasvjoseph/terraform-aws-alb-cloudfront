variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "execution_role_arn" {
  description = "IAM role ARN for ECS task execution."
  type        = string
}

variable "container_image" {
  description = "Container image URL (e.g. 123456789.dkr.ecr.us-east-1.amazonaws.com/my-app:latest)."
  type        = string
}
