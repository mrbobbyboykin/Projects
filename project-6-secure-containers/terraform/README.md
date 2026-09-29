# Project 6 — Terraform

Infrastructure for the secure containerized API lab.

## Status

Not implemented yet. Follow phases in [../docs/ARCHITECTURE.md](../docs/ARCHITECTURE.md).

## Planned apply / destroy

```bat
cd "C:\Users\bboyk\OneDrive\Projects\Projects-git\project-6-secure-containers\terraform"
terraform init
terraform plan
terraform apply
```

When idle:

```bat
terraform destroy
```

## Defaults for cost control

- Region: `us-east-1`
- One Fargate task (`0.25 vCPU / 0.5 GB`)
- No NAT Gateway unless you explicitly enable a `enable_nat_gateway` flag
- HTTP on ALB first; add ACM HTTPS only if you want that stretch goal
