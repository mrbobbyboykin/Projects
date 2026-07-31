output "aws_region" {
  description = "Deployed region."
  value       = var.aws_region
}

output "vpc_id" {
  description = "VPC identifier."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs (ALB placement)."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs (app tier when NAT enabled, RDS)."
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_id" {
  description = "NAT gateway ID (null if disabled)."
  value       = module.vpc.nat_gateway_id
}

output "alb_dns_name" {
  description = "ALB DNS name — open http://<value>/ in a browser (null if compute disabled)."
  value       = var.enable_compute ? module.alb[0].dns_name : null
}

output "asg_name" {
  description = "Auto Scaling Group name (null if compute disabled)."
  value       = var.enable_compute ? module.asg[0].asg_name : null
}

output "rds_endpoint" {
  description = "RDS endpoint hostname (null if RDS disabled)."
  value       = var.enable_rds && var.enable_compute ? module.rds[0].endpoint : null
}

output "rds_port" {
  value = var.enable_rds && var.enable_compute ? module.rds[0].port : null
}

output "rds_master_username" {
  value = var.enable_rds && var.enable_compute ? module.rds[0].master_username : null
}

output "rds_master_password" {
  description = "Sensitive — use: terraform output -raw rds_master_password"
  value       = var.enable_rds && var.enable_compute ? module.rds[0].master_password : null
  sensitive   = true
}

output "s3_bucket_name" {
  description = "Static assets bucket (null if disabled)."
  value       = var.enable_s3_static ? module.s3_static[0].bucket_name : null
}

output "cloudwatch_dashboard_name" {
  description = "CloudWatch dashboard name (null if monitoring disabled)."
  value       = var.enable_monitoring && var.enable_compute ? module.monitoring[0].dashboard_name : null
}
