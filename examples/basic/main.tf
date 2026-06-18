module "alb_cloudfront" {
  source = "../../"

  name    = "my-app"
  vpc_cidr = "10.0.0.0/16"
  azs     = ["us-east-1a", "us-east-1b"]

  private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = "dev"
    Project     = "my-app"
  }

  lb_resources = {
    app = {
      lb_name                    = "my-app-alb"
      lb_target_type             = "ip"
      internal                   = true
      tg_name                    = "my-app-tg"
      tg_port_number             = 80
      lb_port_number             = 80
      lb_target_id               = []
      load_balancer_type         = "application"
      enable_deletion_protection = false
      use_for                    = "ecs"
      tags = {
        Environment = "dev"
      }
    }
  }

  ecs_resources = {
    app = {
      ecs_cluster_name                  = "my-app-cluster"
      ecs_task_def_family               = "my-app"
      ecs_task_def_network_mode         = "awsvpc"
      ecs_task_requires_compatibilities = ["FARGATE"]
      ecs_task_def_cpu                  = 256
      ecs_task_def_memory               = 512
      ecs_task_def_execution_role_arn   = var.execution_role_arn
      ecs_task_def_container_name       = "my-app"
      ecs_image_url                     = var.container_image
      ecs_task_def_container_port       = 80
      ecs_task_def_host_port            = 80
      ecs_awslogs_group                 = "/ecs/my-app"
      aws_region                        = var.aws_region
      ecs_service_name                  = "my-app-service"
      ecs_launch_type                   = "FARGATE"
      ecs_service_container_name        = "my-app"
      ecs_service_container_port        = 80
      desired_count                     = 1
    }
  }

  cloudfront_resources = {
    app = {
      vpc_origin_name        = "my-app-origin"
      http_port              = 80
      origin_protocol_policy = "http-only"
      comment                = "my-app CloudFront distribution"
      price_class            = "PriceClass_100"
      tags = {
        Environment = "dev"
      }
    }
  }
}
