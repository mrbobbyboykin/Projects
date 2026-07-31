# Remote state (Phase 5)

Terraform **remote state** stores `terraform.tfstate` in **S3** and uses **DynamoDB** so two applies cannot corrupt state at the same time.

```text
bootstrap/  (local state)     main terraform/  (remote state)
   │                                │
   ├── S3 tfstate bucket  <─────────┤ reads/writes state
   └── DynamoDB locks     <─────────┤ locks during plan/apply
```

## Step 1 — Create the backend (once)

```bash
cd project-2-aws-infrastructure/terraform/bootstrap
terraform init
terraform apply
terraform output backend_hcl_snippet
```

Copy the snippet into `../backend.hcl` (that file is gitignored).

Example:

```hcl
bucket         = "portfolio-lab-tfstate-a1b2c3d4"
key            = "project-2/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "portfolio-lab-terraform-locks"
encrypt        = true
```

Or:

```bash
cd ../
cp backend.hcl.example backend.hcl
# Edit bucket = from: terraform -chdir=bootstrap output -raw state_bucket_name
```

## Step 2 — Enable the S3 backend in the main project

In `versions.tf`, **uncomment** the `backend "s3" {}` block (partial config — details come from `backend.hcl`).

## Step 3 — Migrate (or init) state

```bash
cd project-2-aws-infrastructure/terraform
terraform init -backend-config=backend.hcl
```

- If you already had a local `terraform.tfstate`, Terraform asks to **migrate** — answer `yes`.
- If state was empty / already destroyed, init just configures the remote backend.

Confirm:

```bash
terraform plan
# Should talk to AWS using state from S3 (no surprise recreate of bootstrap resources)
```

## Cost / teardown notes

| Stack | Destroy? |
|-------|----------|
| Main lab (VPC, ALB, …) | Yes — destroy when idle |
| **Bootstrap** (state bucket + lock table) | **No** while using remote state; nearly free idle |

To fully remove remote state later: migrate back to local (advanced) or empty the bucket, then `terraform destroy` inside `bootstrap/`.

## Portfolio evidence

Screenshot: S3 bucket (versioning on) + DynamoDB table `portfolio-lab-terraform-locks` + a successful `terraform init` showing the S3 backend.
