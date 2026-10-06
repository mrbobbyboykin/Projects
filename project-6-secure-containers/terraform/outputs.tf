output "aws_region" {
  value = var.aws_region
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "ecr_repository_name" {
  value = aws_ecr_repository.api.name
}

output "ecr_repository_url" {
  description = "Use this as the Docker registry path for tag/push."
  value       = aws_ecr_repository.api.repository_url
}

output "ecr_registry_id" {
  value = aws_ecr_repository.api.registry_id
}

output "docker_login_command" {
  description = "Authenticate Docker to this account's ECR."
  value       = "aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
}

output "docker_push_commands" {
  description = "Tag and push the local Phase 0 image."
  value       = <<-EOT
    docker tag project6-api:local ${aws_ecr_repository.api.repository_url}:latest
    docker push ${aws_ecr_repository.api.repository_url}:latest
  EOT
}

output "alb_dns_name" {
  description = "Public ALB hostname — hit http://<this>/health"
  value       = aws_lb.api.dns_name
}

output "api_health_url" {
  value = "http://${aws_lb.api.dns_name}/health"
}

output "api_info_url" {
  value = "http://${aws_lb.api.dns_name}/info"
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  value = aws_ecs_service.api.name
}

output "cloudwatch_log_group" {
  value = aws_cloudwatch_log_group.api.name
}

output "secretsmanager_secret_arn" {
  description = "Secrets Manager ARN injected as APP_SECRET into the ECS task."
  value       = aws_secretsmanager_secret.app.arn
}

output "secretsmanager_secret_name" {
  value = aws_secretsmanager_secret.app.name
}

output "ecs_execution_role_name" {
  value = aws_iam_role.ecs_execution.name
}

output "ecs_task_role_name" {
  value = aws_iam_role.ecs_task.name
}

output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}

output "alarm_unhealthy_hosts_name" {
  value = aws_cloudwatch_metric_alarm.unhealthy_hosts.alarm_name
}

output "alarm_target_4xx_name" {
  value = aws_cloudwatch_metric_alarm.target_4xx.alarm_name
}

output "budget_name" {
  value = aws_budgets_budget.lab.name
}

data "aws_caller_identity" "current" {}
