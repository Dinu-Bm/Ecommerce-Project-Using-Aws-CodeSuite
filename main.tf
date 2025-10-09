
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

/*module "ec2" {
  source = "./modules/ec2"

  environment          = var.environment
  instance_type        = var.app_instance_type
  key_name            = var.key_name  # Your existing key
  private_subnet_ids  = module.vpc.private_app_subnet_ids
  app_security_group_id = module.security_groups.app_sg_id
  target_group_arn    = module.alb.target_group_arn
  db_endpoint         = module.rds.db_endpoint
  db_name             = module.rds.db_name
  db_username         = var.db_username
  db_password         = var.db_password
}
*/