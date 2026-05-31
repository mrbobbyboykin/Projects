# RDS module (Phase 2)

Planned resources:

- `aws_db_subnet_group` (private subnets)
- `aws_db_instance` — **Multi-AZ** for portfolio story (note cost in README)
- Security group: allow DB port from app tier SG only
- No public accessibility

Expected inputs: `vpc_id`, `private_subnet_ids`, `app_security_group_id`

Expected outputs: `endpoint`, `port`, `db_identifier`
