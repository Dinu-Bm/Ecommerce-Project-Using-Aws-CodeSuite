output "public_subnet_ids" {
  description = "IDs of all public subnets"
  value       = aws_subnet.public[*].id
}

output "private_app_subnet_ids" {
  description = "IDs of all private app subnets"
  value       = aws_subnet.private_app[*].id
}

output "private_db_subnet_ids" {
  description = "IDs of all private DB subnets"
  value       = aws_subnet.private_db[*].id
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}
