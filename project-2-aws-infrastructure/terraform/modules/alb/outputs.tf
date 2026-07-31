output "dns_name" {
  description = "ALB DNS name (http://<this>/)."
  value       = aws_lb.this.dns_name
}

output "alb_arn" {
  value = aws_lb.this.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.app.arn
}

output "security_group_id" {
  value = aws_security_group.alb.id
}

output "alb_arn_suffix" {
  description = "ALB ARN suffix for CloudWatch dimensions."
  value       = aws_lb.this.arn_suffix
}

output "target_group_arn_suffix" {
  description = "Target group ARN suffix for CloudWatch dimensions."
  value       = aws_lb_target_group.app.arn_suffix
}
