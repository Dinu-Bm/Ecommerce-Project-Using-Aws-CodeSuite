# output "codebuild_project_name" {
#   value = aws_codebuild_project.ecommerce.name
# }

output "codebuild_project_arn" {
  value = aws_codebuild_project.ecommerce.arn
}

output "codedeploy_app_name" {
  value = aws_codedeploy_app.ecommerce.name
}

output "codedeploy_deployment_group_name" {
  value = aws_codedeploy_deployment_group.ecommerce.deployment_group_name
}

# output "codepipeline_name" {
#   value = aws_codepipeline.ecommerce.name
# }

# output "codepipeline_arn" {
#   value = aws_codepipeline.ecommerce.arn
# }

output "codepipeline_bucket_name" {
  value = aws_s3_bucket.codepipeline_artifacts.bucket
}

output "codepipeline_bucket_arn" {
  value = aws_s3_bucket.codepipeline_artifacts.arn
}
