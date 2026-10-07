# Phase 5 — Amazon GuardDuty (account/region threat detection)

resource "aws_guardduty_detector" "main" {
  count = var.enable_guardduty ? 1 : 0

  enable = true

  tags = {
    Name = "${var.project_name}-${var.environment}-guardduty"
  }
}
