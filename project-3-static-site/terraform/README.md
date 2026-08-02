# Project 3 — Terraform

## Prerequisites

- AWS credentials configured for the same account as Project 2
- Terraform `>= 1.5`
- (Optional) Project 2 bootstrap remote state already applied

## Deploy (local state first)

```bat
cd project-3-static-site\terraform
copy terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

Open the URL from:

```bat
terraform output cloudfront_url
```

CloudFront can take a few minutes after apply before the site responds.

Click **Count this visit** on the page — it calls `/api/visitors` through CloudFront.

## Optional: remote state (reuse Project 2 bootstrap)

1. Copy `backend.hcl.example` → `backend.hcl` and set the real state bucket name.
2. Uncomment `backend "s3" {}` in `versions.tf`.
3. `terraform init -backend-config=backend.hcl` (migrate state when prompted).

State key: `project-3/terraform.tfstate` (separate from Project 2).

## Tear down

```bat
terraform destroy
```

Do **not** destroy Project 2 `terraform/bootstrap` if you still use remote state.
