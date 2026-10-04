# Project 6 — Terraform

Infrastructure for the secure containerized API lab.

## Status

- **Phase 1 (ECR):** implemented
- **Phase 2 (VPC + ALB + ECS Fargate):** implemented (cheap path — public subnets, no NAT)
- **Phase 3 (Secrets Manager):** implemented — `APP_SECRET` injected from Secrets Manager
- **Phase 4+:** alarms, budget, optional CI

## Phase 3 notes

- Secret name: `project6/lab/app-secret`
- Task definition uses `secrets` → Secrets Manager ARN (not a plaintext `environment` value)
- **Execution role** can `GetSecretValue` so ECS can inject the secret at start
- **Task role** can `GetSecretValue` on that secret only (least privilege)
- App still only reports `secret_configured: true/false` via `/info`

## Apply

```powershell
cd "C:\Users\bboyk\OneDrive\Projects\Projects-git\project-6-secure-containers\terraform"
copy terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

## Test Phase 2

```powershell
terraform output api_health_url
terraform output api_info_url

curl.exe (terraform output -raw api_health_url)
curl.exe (terraform output -raw api_info_url)
```

Console checks:
- **ECS → Clusters → project6-lab → Services** (1/1 running)
- **EC2 → Target Groups → project6-lab-tg** (healthy)
- **CloudWatch → Log groups → /ecs/project6-lab-api**

## Push a new image (after local rebuild)

```powershell
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 345485442145.dkr.ecr.us-east-1.amazonaws.com
docker tag project6-api:local 345485442145.dkr.ecr.us-east-1.amazonaws.com/project6-api:latest
docker push 345485442145.dkr.ecr.us-east-1.amazonaws.com/project6-api:latest
aws ecs update-service --cluster project6-lab --service project6-lab-api --force-new-deployment --region us-east-1
```

## Cost control

- Region: `us-east-1`
- 1 Fargate task (`256` CPU / `512` MiB)
- No NAT Gateway
- Log retention: 7 days
- When idle: `terraform destroy` **or** set `desired_count = 0` and apply (ALB still costs until destroyed)

## Destroy

```powershell
terraform destroy
```
