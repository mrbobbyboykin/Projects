# Auto Scaling module (Phase 2)

Planned resources:

- Launch template (Amazon Linux 2023 or custom AMI)
- `aws_autoscaling_group` in **private subnets**
- Target tracking or step scaling on **CPU** (document policy choice in README)
- Security group: allow app port from ALB SG only

Expected inputs: `private_subnet_ids`, `target_group_arn`, `alb_security_group_id`

Expected outputs: `asg_name`, `security_group_id`
