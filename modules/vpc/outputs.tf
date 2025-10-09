
output "vpc_id" {
  description = "ID of the created VPC"  
  value       = aws_vpc.main.id         
}


output "public_subnet_ids" {
  description = "List of public subnet IDs"  
  value       = aws_subnet.public[*].id   
}


output "private_app_subnet_ids" {
  description = "List of private application subnet IDs" 
  value       = aws_subnet.private_app[*].id
}


output "private_db_subnet_ids" {
  description = "List of private database subnet IDs"  
  value       = aws_subnet.private_db[*].id
}