# VPC ID input variable
variable "vpc_id" {
  description = "VPC ID where security groups will be created"  # Needed to create SGs in correct VPC
  type        = string
}

# Environment name input variable
variable "environment" {
  description = "Environment name for security group names"  # For naming and tagging
  type        = string
}