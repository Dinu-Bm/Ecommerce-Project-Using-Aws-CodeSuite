variable "environment" {
  type        = string
  description = "Environment name (dev/prod/staging)"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "aws_account_id" {
  type        = string
  description = "AWS account ID"
}

variable "github_owner" {
  type        = string
  description = "GitHub owner or organization"
}

variable "github_repo" {
  type        = string
  description = "GitHub repository name"
}

variable "github_branch" {
  type        = string
  description = "GitHub branch"
  default     = "main"
}

variable "github_token" {
  type        = string
  description = "GitHub personal access token"
  sensitive   = true
}

variable "autoscaling_group_name" {
  type        = string
  description = "Auto Scaling Group name for CodeDeploy"
}

variable "target_group_name" {
  type        = string
  description = "Target group name for ALB"
}

variable "ecr_repository_url" {
  type        = string
  description = "ECR repository URL for Docker image"
}
