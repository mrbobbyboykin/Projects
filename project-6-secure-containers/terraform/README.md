# Project 6 — Terraform

Infrastructure for the secure containerized API lab.

## Status

- **Phase 1 (ECR):** implemented — create repo, push local Docker image
- **Phases 2+:** not yet (ECS / ALB / Secrets)

## Phase 1 — create ECR and push image

```powershell
cd "C:\Users\bboyk\OneDrive\Projects\Projects-git\project-6-secure-containers\terraform"
copy terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

Authenticate Docker to ECR, then tag and push (use the exact URL from `terraform output`):

```powershell
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com

docker tag project6-api:local ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/project6-api:latest
docker push ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/project6-api:latest
```

Or print helper commands:

```powershell
terraform output -raw docker_login_command
terraform output -raw docker_push_commands
```

Confirm in AWS Console: **ECR → Repositories → project6-api → Images**.  
With scan-on-push enabled, open the **Vulnerabilities** / scan results tab after the push.

## Defaults for cost control

- Region: `us-east-1`
- Lifecycle policy keeps only the last 5 images
- `force_delete = true` so `terraform destroy` works in the lab
- No NAT / ALB / Fargate until Phase 2

## Destroy (when idle)

```powershell
terraform destroy
```

Note: destroy removes the ECR repo and images. Re-push after recreating.
