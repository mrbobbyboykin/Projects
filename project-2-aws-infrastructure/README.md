# Project 2 — AWS Cloud Infrastructure

[← Back to portfolio index](../README.md)

**Status:** In progress — **Phase 1 (VPC)** scaffold is ready for `terraform plan` / `apply`. ALB, ASG, RDS, S3, and CloudWatch modules are stubbed for incremental implementation.

Reproducible AWS lab: multi-AZ **VPC** foundation, then **ALB + ASG**, **RDS Multi-AZ**, **S3**, and **CloudWatch** — all driven by **Terraform** (`variables.tf`, `outputs.tf`, modular layout).

## Architecture

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the target diagram and security-group plan.

## Prerequisites

| Requirement | Notes |
|-------------|--------|
| AWS account | Free tier helps; **NAT Gateway and RDS Multi-AZ incur cost** — tear down when idle |
| AWS CLI v2 | Configured: `aws configure` or SSO |
| Terraform ≥ 1.5 | [Install](https://developer.hashicorp.com/terraform/install) |
| IAM permissions | VPC, EC2, ELB, RDS, S3, CloudWatch (expand as modules are added) |

Verify credentials:

```bash
aws sts get-caller-identity
```

## Repository layout

```
project-2-aws-infrastructure/
├── README.md                 ← you are here
├── docs/
│   └── ARCHITECTURE.md
└── terraform/
    ├── main.tf               ← composes modules
    ├── variables.tf
    ├── outputs.tf
    ├── providers.tf
    ├── versions.tf
    ├── terraform.tfvars.example
    └── modules/
        ├── vpc/              ← Phase 1 (implemented)
        ├── alb/              ← Phase 2 stub
        ├── asg/
        ├── rds/
        ├── s3/
        └── cloudwatch/
```

## Deploy (Phase 1 — VPC only)

From this folder:

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars if you change region or CIDRs

terraform init
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

Review outputs:

```bash
terraform output
```

Expected resources (Phase 1): VPC, IGW, 2 public + 2 private subnets, route tables, optional **single NAT gateway**.

### Cost warning

A **NAT Gateway** bills hourly plus data processing. For learning, **`enable_nat_gateway = false`** in `terraform.tfvars` until you need private subnet internet egress (ASG/RDS updates). **Always destroy** lab stacks when not in use.

## Teardown

```bash
cd terraform
terraform destroy
```

Confirm with `yes`. Verify in AWS Console: VPC, NAT, EIP released.

If state is corrupted or resources were deleted manually:

```bash
terraform refresh
terraform destroy
```

## Enable later phases

In `terraform.tfvars`, flip toggles as modules are implemented and uncomment blocks in `main.tf`:

```hcl
enable_compute    = true   # ALB + ASG
enable_rds        = true
enable_s3_static  = true
enable_monitoring = true
```

Implement each module under `terraform/modules/` (see module README files).

## Remote state (recommended before serious work)

Uncomment the `backend "s3"` block in `terraform/versions.tf` after creating:

- S3 bucket (versioning on)
- DynamoDB table for state locking

Never commit `terraform.tfvars` or state files (see `terraform/.gitignore`).

## Portfolio evidence (when built)

Capture for GitHub / interviews:

- `terraform plan` summary (sanitized account IDs)
- AWS Console or `terraform output` showing VPC + subnets
- ALB healthy targets + ASG scale event
- CloudWatch dashboard screenshot
- `terraform destroy` confirmation (cost discipline)

Store under `docs/milestone-screenshots/` (create when ready).

## Related work

- **Project 1 (complete):** [Ansible multi-node RHEL lab](../project-1-ansible-lab/README.md)
- **Project 3 (future):** CI/CD — CodePipeline, CodeBuild, CodeDeploy (same monorepo or new folder)

## License

Same as monorepo — [MIT](../project-1-ansible-lab/LICENSE).
