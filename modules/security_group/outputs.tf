# Output ALB security group ID
output "alb_sg_id" {
  description = "ALB Security Group ID"  # Will be used by ALB module
  value       = aws_security_group.alb.id
}

# Output application security group ID
output "app_sg_id" {
  description = "Application Security Group ID"  # Will be used by EC2 module
  value       = aws_security_group.app.id
}

# Output database security group ID
output "database_sg_id" {
  description = "Database Security Group ID"  # Will be used by RDS module
  value       = aws_security_group.database.id
}

# Output CodeDeploy security group ID
output "codedeploy_sg_id" {
  description = "CodeDeploy Security Group ID"  # Will be used by CodeDeploy
  value       = aws_security_group.codedeploy.id
}