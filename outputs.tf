output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.alb.alb_dns_name
}

output "target_group_arn" {
  description = "Target group ARN"
  value       = module.alb.target_group_arn
}
