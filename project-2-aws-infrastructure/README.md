# Project 2 — AWS Cloud Infrastructure

[← Back to portfolio index](../README.md)

**Status:** In progress — **Phase 1 (VPC)** and **Phase 2 (ALB + ASG)** are implemented. RDS, S3, and CloudWatch modules are stubbed for later.

Reproducible AWS lab: multi-AZ **VPC**, public **ALB**, **Auto Scaling** app tier (nginx), then planned **RDS Multi-AZ**, **S3**, and **CloudWatch** — all driven by **Terraform**.

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
        ├── alb/              ← Phase 2 (implemented)
        ├── asg/              ← Phase 2 (implemented)
        ├── rds/              ← Phase 3 stub
        ├── s3/
        └── cloudwatch/
```

## Deploy

### Phase 1 — VPC only

In `terraform.tfvars`:

```hcl
enable_nat_gateway = false
enable_compute     = false
```

### Phase 2 — VPC + ALB + ASG

```hcl
enable_nat_gateway = false   # ASG uses public subnets (cheap lab)
enable_compute     = true
asg_desired_capacity = 2
```

From the `terraform/` folder:

```bash
cd terraform
# Ensure terraform.tfvars exists (copy from example if needed)

terraform init
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
terraform output
```

Open the ALB in a browser:

```bash
# After apply:
terraform output alb_dns_name
# Visit http://<alb_dns_name>/
```

Expect a simple nginx page showing the instance hostname (refresh a few times — with 2 instances you may hit different hosts).

Expected Phase 2 resources (in addition to VPC): ALB, listener, target group, ASG, launch template, app + ALB security groups, IAM instance profile (SSM).

### Cost warning

A **NAT Gateway** bills hourly plus data processing. For learning, keep **`enable_nat_gateway = false`** until you need private-subnet egress. EC2 (`t3.micro`) and ALB also incur charges — **always destroy** when idle.

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

Phase 2 compute is ready (`enable_compute = true`). For later modules, flip toggles and implement under `terraform/modules/`:

```hcl
enable_rds        = true
enable_s3_static  = true
enable_monitoring = true
```

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
