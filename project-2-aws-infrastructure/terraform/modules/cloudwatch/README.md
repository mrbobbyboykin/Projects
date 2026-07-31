# CloudWatch module (Phase 4)

Dashboard and alarms for the lab stack (ALB, ASG, optional RDS).

## Resources

- CloudWatch dashboard: ALB request count, unhealthy hosts, 5xx, ASG CPU (+ RDS CPU/storage when enabled)
- Alarms: unhealthy hosts > 0, ASG CPU > 70% (+ RDS CPU/storage when enabled)
- Optional SNS email subscription via `alarm_email`

## Inputs

| Name | Required | Notes |
|------|----------|--------|
| `alb_arn_suffix`, `target_group_arn_suffix` | yes | From ALB module |
| `asg_name` | yes | From ASG module |
| `rds_identifier` | no | Set when RDS is enabled |
| `alarm_email` | no | Empty = alarms only (no email) |

## Outputs

`dashboard_name`, `sns_topic_arn`
