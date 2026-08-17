terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Architecture = "staging-option-1-prod-multi-az"
    }
  }
}

# Networking Module
module "networking" {
  source = "../../modules/networking"

  project_name      = var.project_name
  environment       = var.environment
  vpc_cidr          = var.vpc_cidr
  num_azs           = 2
  enable_nat_gateway = true

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Architecture = "staging-option-1-prod-multi-az"
  }
}

# Staging Lightsail Module
module "staging_lightsail" {
  source = "../../modules/staging-lightsail"

  project_name = var.project_name
  environment  = "staging"
  bundle_id    = "medium_2_8"
  blueprint_id = "amazon_linux_2"

  ports = [
    { from = 80, to = 80, protocol = "tcp" },
    { from = 443, to = 443, protocol = "tcp" },
    { from = 22, to = 22, protocol = "tcp" }
  ]

  tags = {
    Project     = var.project_name
    Environment = "staging"
    ManagedBy   = "Terraform"
    Architecture = "staging-option-1-prod-multi-az"
  }
}

# Production EKS Module
module "production_eks" {
  source = "../../modules/production-eks"

  project_name            = var.project_name
  environment             = "production"
  vpc_id                  = module.networking.vpc_id
  vpc_cidr                = module.networking.vpc_cidr
  private_subnet_ids      = module.networking.private_subnet_ids
  kubernetes_version      = var.kubernetes_version
  cluster_endpoint_public_access = false
  node_instance_type      = "t3.xlarge"
  node_group_desired_size = 2
  node_group_min_size     = 2
  node_group_max_size     = 4
  node_volume_size        = 100
  node_volume_type        = "gp3"

  tags = {
    Project     = var.project_name
    Environment = "production"
    ManagedBy   = "Terraform"
    Architecture = "staging-option-1-prod-multi-az"
  }
}

# ALB Module
module "alb" {
  source = "../../modules/alb"

  project_name = var.project_name
  environment  = "production"
  vpc_id       = module.networking.vpc_id
  subnet_ids   = module.networking.public_subnet_ids
  internal     = false
  target_port  = 80
  target_protocol = "HTTP"
  target_type  = "instance"
  enable_https = false

  tags = {
    Project     = var.project_name
    Environment = "production"
    ManagedBy   = "Terraform"
    Architecture = "staging-option-1-prod-multi-az"
  }
}

# S3 Module
module "s3" {
  source = "../../modules/s3"

  project_name = var.project_name
  environment  = var.environment
  enable_lifecycle_rules = true
  transition_to_intelligent_tiering_days = 90

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Architecture = "staging-option-1-prod-multi-az"
  }
}

# ECR Module
module "ecr" {
  source = "../../modules/ecr"

  project_name = var.project_name
  environment  = var.environment
  scan_on_push = true
  max_image_count = 20

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Architecture = "staging-option-1-prod-multi-az"
  }
}

# RDS Multi-AZ Module
module "rds" {
  source = "../../modules/rds-multi-az"

  project_name                = var.project_name
  environment                 = var.environment
  vpc_id                      = module.networking.vpc_id
  subnet_ids                  = module.networking.database_subnet_ids
  allowed_security_group_id   = module.production_eks.node_group_security_group_id
  instance_class              = "db.t3.medium"
  allocated_storage           = 100
  storage_type                = "gp3"
  storage_encrypted           = true
  engine_version              = "15.4"
  db_name                     = var.db_name
  username                    = var.db_username
  password                    = var.db_password
  backup_retention_period     = 7
  deletion_protection         = true

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Architecture = "staging-option-1-prod-multi-az"
  }
}

# Redis Multi-AZ Module
module "redis" {
  source = "../../modules/redis-multi-az"

  project_name                = var.project_name
  environment                 = var.environment
  vpc_id                      = module.networking.vpc_id
  subnet_ids                  = module.networking.database_subnet_ids
  allowed_security_group_id   = module.production_eks.node_group_security_group_id
  node_type                   = "cache.t4g.medium"
  engine_version              = "7.0"
  at_rest_encryption_enabled  = true
  transit_encryption_enabled  = true
  auth_token                  = var.redis_auth_token
  snapshot_retention_limit    = 7

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Architecture = "staging-option-1-prod-multi-az"
  }
}
