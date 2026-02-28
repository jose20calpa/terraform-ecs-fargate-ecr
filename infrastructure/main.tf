terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
module "networking" {
  source = "./networking"
  project_name = var.ecs_taller_Angular
  environment  = var.environment
  aws_region   = var.aws_region
}
module "security_groups" {
  source = "./security_groups"

  vpc_id = module.networking.vpc_id
}
module "ecr" {
  source = "./ecr"

  repository_name = "my-angular-app"
}
module "alb" {
  source = "./alb"

  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id
}
module "ecs" {
  source = "./ecs"

  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
  ecs_sg_id          = module.security_groups.ecs_sg_id
  target_group_arn   = module.alb.target_group_arn
  repository_url     = module.ecr.repository_url
}

# Outputs
output "ecr_repository_url" {
  description = "ECR repository URL for pushing Docker images"
  value       = module.ecr.repository_url
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}