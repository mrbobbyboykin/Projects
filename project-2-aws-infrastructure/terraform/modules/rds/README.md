# RDS module (Phase 3)

Private MySQL database for the portfolio lab. **Default is Single-AZ** for cost control; set `multi_az = true` for a short HA demo.

## Resources

- Security group (DB port **only** from app tier SG)
- `aws_db_subnet_group` (private subnets, 2 AZs)
- `aws_db_instance` — `db.t3.micro`, 20 GB gp3, not publicly accessible
- `random_password` for master user (sensitive output)

## Inputs

| Name | Default | Notes |
|------|---------|--------|
| `private_subnet_ids` | — | From VPC module |
| `app_security_group_id` | — | From ASG module (`enable_compute` required) |
| `multi_az` | `false` | Single-AZ lab default |
| `db_instance_class` | `db.t3.micro` | Free-tier friendly (Single-AZ) |

## Outputs

`endpoint`, `port`, `db_identifier`, `db_name`, `master_username`, `master_password` (sensitive), `security_group_id`

## Cost

Destroy when done. Single-AZ micro is roughly **~$0.017/hr** plus small storage. Multi-AZ ~2× compute.
