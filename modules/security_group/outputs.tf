output "alb_sg_id" {
  description = "Security group ID for ALB"
  value       = aws_security_group.alb.id
}

output "app_sg_id" {
  description = "Security group ID for Application instances"
  value       = aws_security_group.app.id
}

output "database_sg_id" {
  description = "Security group ID for RDS"
  value       = aws_security_group.database.id
}

output "codedeploy_sg_id" {
  description = "Security group ID for CodeDeploy"
  value       = aws_security_group.codedeploy.id
}
