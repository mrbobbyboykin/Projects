# Auto Scaling module (Phase 2)

Launches Amazon Linux 2023 instances behind the ALB target group, with nginx via user-data.

## Resources

- App security group (app port **only** from ALB SG)
- IAM instance profile + **SSM** managed policy (Session Manager, no SSH key required)
- Launch template (AL2023, user-data installs nginx)
- Auto Scaling Group (ELB health checks)
- Target-tracking scaling policy (CPU ~50%)

## Lab networking note

| Mode | Subnets | Public IP | When |
|------|---------|-----------|------|
| Cost-control (default) | **Public** | Yes | `enable_nat_gateway = false` |
| Production-like | **Private** | No | `enable_nat_gateway = true` |

Root module picks subnet IDs and `associate_public_ip` from the NAT toggle.

## Inputs

`vpc_id`, `subnet_ids`, `target_group_arn`, `alb_security_group_id`, sizing vars, `associate_public_ip`

## Outputs

`asg_name`, `security_group_id`, `launch_template_id`
