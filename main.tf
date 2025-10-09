module "vpc" {
  source = "./modules/vpc"  # Path to VPC module

  vpc_cidr           = var.vpc_cidr            # VPC IP range
  environment        = var.environment         # Environment name
  availability_zones = var.availability_zones  # Availability zones
}