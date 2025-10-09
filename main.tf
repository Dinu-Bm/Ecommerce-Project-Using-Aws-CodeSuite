
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


