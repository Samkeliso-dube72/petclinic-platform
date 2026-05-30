output "platform_security_group_id" {
  description = "Platform base security group ID"
  value       = aws_security_group.platform.id
}

output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb.id
}

output "pods_security_group_id" {
  description = "Pods security group ID"
  value       = aws_security_group.pods.id
}

output "rds_security_group_id" {
  description = "RDS security group ID"
  value       = aws_security_group.rds.id
}
