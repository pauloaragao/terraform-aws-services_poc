terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.37"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# -----------------------------------------------------------------------------
# EC2
# -----------------------------------------------------------------------------
module "ec2" {
  count  = var.deploy_ec2 ? 1 : 0
  source = "./modules/ec2"

  aws_region    = var.aws_region
  instance_name = var.ec2_instance_name
  instance_type = var.ec2_instance_type
}

# -----------------------------------------------------------------------------
# RDS
# -----------------------------------------------------------------------------
module "rds" {
  count  = var.deploy_rds ? 1 : 0
  source = "./modules/rds"

  aws_region   = var.aws_region
  db_name      = var.rds_db_name
  db_username  = var.rds_db_username
  db_password  = var.rds_db_password
  allowed_cidr = var.rds_allowed_cidr
}

# -----------------------------------------------------------------------------
# Lambda
# -----------------------------------------------------------------------------
module "lambda" {
  count  = var.deploy_lambda ? 1 : 0
  source = "./modules/lambda"

  aws_region    = var.aws_region
  function_name = var.lambda_function_name
}

# -----------------------------------------------------------------------------
# Bedrock
# -----------------------------------------------------------------------------
module "bedrock" {
  count  = var.deploy_bedrock ? 1 : 0
  source = "./modules/bedrock"

  aws_region        = var.aws_region
  agent_name        = var.bedrock_agent_name
  agent_alias_name  = var.bedrock_agent_alias_name
  foundation_model  = var.bedrock_foundation_model
  agent_instruction = var.bedrock_agent_instruction
}

# -----------------------------------------------------------------------------
# EKS
# -----------------------------------------------------------------------------
module "eks" {
  count  = var.deploy_eks ? 1 : 0
  source = "./modules/eks"

  aws_region         = var.aws_region
  cluster_name       = var.eks_cluster_name
  node_capacity_type = var.eks_node_capacity_type
  desired_size       = var.eks_desired_size
  min_size           = var.eks_min_size
  max_size           = var.eks_max_size
}
