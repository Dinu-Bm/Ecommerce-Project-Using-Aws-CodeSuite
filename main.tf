
module "vpc" {
  source = "./modules/vpc"  # Path to VPC module

  vpc_cidr           = var.vpc_cidr            # VPC IP range
  environment        = var.environment         # Environment name
  availability_zones = var.availability_zones  # Availability zones
}

module "security_groups" {
  source = "./modules/security_group"  # Path to security group module

  vpc_id      = module.vpc.vpc_id      # VPC ID from VPC module
  environment = var.environment        # Environment name
}

module "s3" {
  source = "./modules/s3"

  environment = var.environment
}

module "ecr" {
  source = "./modules/ecr"

  environment = var.environment
}

module "rds" {
  source = "./modules/rds"

  environment        = var.environment
  instance_type      = var.db_instance_type
  db_name           = "ecommercedb"
  db_username       = var.db_username
  db_password       = var.db_password  # From terraform.tfvars
  private_subnet_ids = module.vpc.private_db_subnet_ids
  security_group_id  = module.security_groups.database_sg_id
}

module "alb" {
  source = "./modules/alb"

  environment      = var.environment
  vpc_id          = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  security_group_id = module.security_groups.alb_sg_id
}

module "ec2" {
  source = "./modules/ec2"

  environment           = var.environment
  instance_type         = var.app_instance_type
  key_name              = var.key_name
  private_subnet_ids    = module.vpc.public_subnet_ids  # <--- public subnets now available
  app_security_group_id = module.security_groups.app_sg_id
  target_group_arn      = module.alb.target_group_arn
  db_endpoint           = module.rds.db_endpoint
  db_name               = module.rds.db_name
  db_username           = var.db_username
  db_password           = var.db_password
}

module "codepipeline" {
  source = "./modules/codepipeline"

  environment          = var.environment
  aws_region          = var.aws_region
  aws_account_id      = data.aws_caller_identity.current.account_id
  github_owner        = var.github_owner
  github_repo         = var.github_repo
  github_branch       = var.github_branch
  github_token        = var.github_token
  autoscaling_group_name = module.ec2.autoscaling_group_name
  target_group_name   = split("/", module.alb.target_group_arn)[2]
  ecr_repository_url  = module.ecr.ecr_repository_url
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}