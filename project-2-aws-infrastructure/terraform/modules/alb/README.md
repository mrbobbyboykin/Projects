# Application Load Balancer module (Phase 2)

Planned resources:

- `aws_lb` (application, public subnets)
- `aws_lb_target_group` (HTTP health checks)
- `aws_lb_listener` (HTTP :80; HTTPS :443 when ACM cert added)
- Security group: allow 80/443 from internet → ALB only

Expected inputs: `vpc_id`, `public_subnet_ids`, `project_name`, `environment`

Expected outputs: `dns_name`, `target_group_arn`, `security_group_id`
