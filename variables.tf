# AWS region variable - where resources will be created
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "ap-south-1"  # Default to US East (N. Virginia)
}

# Environment name variable - for tagging and naming
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# VPC CIDR block variable - IP range for our virtual network
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"  # Large IP range for our network
}

# Availability zones variable - for high availability
variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]  # Spread across 2 zones
}

# Application instance type variable
variable "app_instance_type" {
  description = "EC2 instance type for application servers"
  type        = string
  default     = "t2.micro"  # Free tier eligible instance
}

# Database instance type variable
variable "db_instance_type" {
  description = "RDS instance type for database"
  type        = string
  default     = "db.t2.micro"  # Free tier eligible database
}

# Database username variable
variable "db_username" {
  description = "Username for the database administrator"
  type        = string
  default     = "admin"
}

# Database password variable - marked as sensitive
variable "db_password" {
  description = "Password for the database administrator"
  type        = string
  sensitive   = false  
}

# EC2 key pair name variable
variable "key_name" {
  description = "Name of the existing EC2 Key Pair"
  type        = string
  default     = "ecommerce-key"  # Your existing key name
}

# GitHub repository owner variable
variable "github_owner" {
  description = "GitHub owner/organization name"
  type        = string
  default     = "your-github-username"
}

# GitHub repository name variable
variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "ecommerce-app"
}

# GitHub branch variable
variable "github_branch" {
  description = "GitHub branch to deploy from"
  type        = string
  default     = "main"
}

# GitHub token variable for CodePipeline
variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}