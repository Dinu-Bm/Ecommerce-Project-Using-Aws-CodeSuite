# ECR Repository for Docker images
resource "aws_ecr_repository" "ecommerce" {
  name = "${var.environment}-ecommerce-app"  # Repository name

  image_tag_mutability = "MUTABLE"  # Allow tag overwrites

  # Scan images for vulnerabilities on push
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.environment}-ecommerce-app"
    Environment = var.environment
  }
}

# ECR Lifecycle Policy - manage image retention
resource "aws_ecr_lifecycle_policy" "ecommerce" {
  repository = aws_ecr_repository.ecommerce.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        action = {
          type = "expire"
        }
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
      }
    ]
  })
}