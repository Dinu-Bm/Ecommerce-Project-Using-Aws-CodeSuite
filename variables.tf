# AWS region variable
variable "aws_region" {
  description = "AWS region where resources will be created" 
  type        = string                                       
  default     = "ap-south-1"                                
}

# Environment name variable
variable "environment" {
  description = "Environment name (dev, staging, prod)"     
  type        = string
  default     = "dev"
}

# VPC CIDR block variable
variable "vpc_cidr" {
  description = "CIDR block for the VPC"  
  type        = string
  default     = "10.0.0.0/16"         
}

# Availability zones variable
variable "availability_zones" {
  description = "List of availability zones for high availability"  
  type        = list(string)                                       
  default     = ["ap-south-1a", "ap-south-1b"]                     
}

# Application instance type variable
variable "app_instance_type" {
  description = "EC2 instance type for application servers"  
  type        = string
  default     = "t2.micro"  
}

# Database instance type variable
variable "db_instance_type" {
  description = "RDS instance type for database"  
  type        = string
  default     = "db.t3.micro"  
}

# Database username variable
variable "db_username" {
  description = "Database administrator username"  
  type        = string
  default     = "admin"
  sensitive   = false
}

# Database password variable
variable "db_password" {
  description = "Database administrator password" 
  type        = string
  sensitive   = false
}

# EC2 key pair name variable
variable "key_name" {
  description = "Name of the EC2 Key Pair for SSH access"  
  type        = string
  default     = "ecommerce-key"
}

# GitHub repository URL variable
variable "github_repo" {
  description = "GitHub repository URL for CodePipeline"  
  type        = string
  default     = "https://github.com/your-username/ecommerce-app.git"  
}

# GitHub branch variable
variable "github_branch" {
  description = "GitHub branch to deploy"  
  type        = string
  default     = "main"
}

# GitHub token variable
variable "github_token" {
  description = "GitHub personal access token"  
  type        = string
  sensitive   = true
}