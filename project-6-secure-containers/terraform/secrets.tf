# Phase 3 — Secrets Manager (APP_SECRET no longer plain env in the task definition)

resource "aws_secretsmanager_secret" "app" {
  name                    = "${var.project_name}/${var.environment}/app-secret"
  description             = "Demo APP_SECRET for Project 6 API (lab)"
  recovery_window_in_days = 0 # lab: allow immediate delete on terraform destroy
}

resource "aws_secretsmanager_secret_version" "app" {
  secret_id     = aws_secretsmanager_secret.app.id
  secret_string = var.app_secret_demo
}

# Execution role needs GetSecretValue so the ECS agent can inject the secret at task start.
resource "aws_iam_role_policy" "ecs_execution_secrets" {
  name = "${var.project_name}-${var.environment}-ecs-execution-secrets"
  role = aws_iam_role.ecs_execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadAppSecret"
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = [
          aws_secretsmanager_secret.app.arn
        ]
      }
    ]
  })
}

# Task role: app-level permission to read only this secret (least privilege).
resource "aws_iam_role_policy" "ecs_task_secrets" {
  name = "${var.project_name}-${var.environment}-ecs-task-secrets"
  role = aws_iam_role.ecs_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadAppSecretOnly"
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = [
          aws_secretsmanager_secret.app.arn
        ]
      }
    ]
  })
}
