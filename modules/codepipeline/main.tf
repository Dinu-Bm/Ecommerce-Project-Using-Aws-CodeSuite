####################################################
# CloudWatch Log Group
####################################################
resource "aws_cloudwatch_log_group" "codebuild_logs" {
  name              = "/aws/codebuild/${var.environment}-ecommerce"
  retention_in_days = 14
}

####################################################
# IAM Roles for CodeBuild, CodeDeploy, CodePipeline
####################################################
# CodeBuild Role
resource "aws_iam_role" "codebuild_role" {
  name = "${var.environment}-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "codebuild.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  ])
  role       = aws_iam_role.codebuild_role.name
  policy_arn = each.key
}

# CodeDeploy Role
resource "aws_iam_role" "codedeploy_role" {
  name = "${var.environment}-codedeploy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "codedeploy.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_policy" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

# CodePipeline Role
resource "aws_iam_role" "codepipeline_role" {
  name = "${var.environment}-codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "codepipeline.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "codepipeline_policy" {
  name        = "${var.environment}-codepipeline-policy"
  description = "Custom policy for CodePipeline full access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = [
        "codebuild:*",
        "codedeploy:*",
        "codestar-connections:*",
        "s3:*",
        "iam:PassRole",
        "ecr:*",
        "logs:*"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline_attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_policy.arn
}

####################################################
# CodeStar Connection
####################################################
resource "aws_codestarconnections_connection" "github" {
  name          = "${var.environment}-github-connection"
  provider_type = "GitHub"
}

####################################################
# S3 Bucket for CodePipeline
####################################################
resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "codepipeline_artifacts" {
  bucket = "${var.environment}-codepipeline-artifacts-${random_id.suffix.hex}"

  tags = {
    Name        = "${var.environment}-codepipeline-artifacts"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket                  = aws_s3_bucket.codepipeline_artifacts.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

####################################################
# CodeBuild Project
####################################################
resource "aws_codebuild_project" "ecommerce" {
  name         = "${var.environment}-ecommerce-build"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts { type = "CODEPIPELINE" }
environment {
  compute_type    = "BUILD_GENERAL1_SMALL"
  image           = "aws/codebuild/standard:5.0"
  type            = "LINUX_CONTAINER"
  privileged_mode = true

  environment_variable {
    name  = "AWS_DEFAULT_REGION"
    value = var.aws_region
  }

  environment_variable {
    name  = "AWS_ACCOUNT_ID"
    value = var.aws_account_id
  }

  environment_variable {
    name  = "IMAGE_REPO_NAME"
    value = "ecommerce-repo"
  }

  environment_variable {
    name  = "ECR_REPOSITORY_URL"
    value = var.ecr_repository_url
  }
}


  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/buildspec.yml")
  }

  logs_config {
    cloudwatch_logs {
      group_name  = aws_cloudwatch_log_group.codebuild_logs.name
      stream_name = "build-log"
    }
  }

  tags = { Environment = var.environment }
}

####################################################
# CodeDeploy Application
####################################################
resource "aws_codedeploy_app" "ecommerce" {
  name             = "${var.environment}-ecommerce-app"
  compute_platform = "Server"
  tags             = { Environment = var.environment }
}

resource "aws_codedeploy_deployment_group" "ecommerce" {
  app_name              = aws_codedeploy_app.ecommerce.name
  deployment_group_name = "${var.environment}-ecommerce-dg"
  service_role_arn      = aws_iam_role.codedeploy_role.arn
  autoscaling_groups    = [var.autoscaling_group_name]

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  blue_green_deployment_config {
    deployment_ready_option { action_on_timeout = "CONTINUE_DEPLOYMENT" }
    green_fleet_provisioning_option { action = "COPY_AUTO_SCALING_GROUP" }
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  load_balancer_info {
    target_group_info { name = var.target_group_name }
  }

  tags = { Environment = var.environment }
}

####################################################
# CodePipeline
####################################################
resource "aws_codepipeline" "ecommerce" {
  name     = "${var.environment}-ecommerce-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_artifacts.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github.arn
        FullRepositoryId = "${var.github_owner}/${var.github_repo}"
        BranchName       = var.github_branch
        DetectChanges    = "true"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = { ProjectName = aws_codebuild_project.ecommerce.name }
    }
  }

  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      version         = "1"
      input_artifacts = ["build_output"]

      configuration = {
        ApplicationName     = aws_codedeploy_app.ecommerce.name
        DeploymentGroupName = aws_codedeploy_deployment_group.ecommerce.deployment_group_name
      }
    }
  }

  depends_on = [
    aws_codebuild_project.ecommerce,
    aws_codedeploy_app.ecommerce,
    aws_s3_bucket.codepipeline_artifacts
  ]
}
