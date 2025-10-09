# S3 Bucket for application logs
resource "aws_s3_bucket" "logs" {
  bucket = "${var.environment}-ecommerce-logs-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "${var.environment}-ecommerce-logs"
    Environment = var.environment
  }
}

# S3 Bucket for CodePipeline artifacts
resource "aws_s3_bucket" "codepipeline" {
  bucket = "${var.environment}-codepipeline-artifacts-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "${var.environment}-codepipeline-artifacts"
    Environment = var.environment
  }
}

# S3 Bucket for terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "2025-2025-ecommerce-terraform-state-${var.environment}"

  tags = {
    Name        = "ecommerce-terraform-state-${var.environment}"
    Environment = var.environment
  }
}

# Enable versioning for state bucket (for state file history)
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"  # Keep multiple versions of state file
  }
}

# Block public access for all buckets (security)
resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "codepipeline" {
  bucket = aws_s3_bucket.codepipeline.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Random ID for bucket name uniqueness
resource "random_id" "bucket_suffix" {
  byte_length = 8  # 8 bytes = 16 character hex string
}