# Application Load Balancer module (Phase 2)

Creates a public Application Load Balancer that forwards HTTP :80 to an EC2 target group.

## Resources

- Security group (80/tcp from `0.0.0.0/0`)
- `aws_lb` (application, public subnets)
- `aws_lb_target_group` (HTTP `/` health check)
- `aws_lb_listener` (HTTP :80 → target group)

HTTPS / ACM can be added later as a stretch.

## Inputs

| Name | Description |
|------|-------------|
| `project_name`, `environment` | Naming / tags |
| `vpc_id` | VPC from Phase 1 |
| `public_subnet_ids` | At least 2 AZs |
| `app_port` | Target port (default 80) |

## Outputs

`dns_name`, `alb_arn`, `target_group_arn`, `security_group_id`
