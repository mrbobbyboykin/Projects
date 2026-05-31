# Project 2 — Target architecture

Planned AWS layout for the portfolio stack (Terraform-managed).

## High-level flow

```mermaid
flowchart TB
  Users[Users / browser]
  ALB[Application Load Balancer\npublic subnets]
  ASG[Auto Scaling Group\nEC2 app tier\nprivate subnets]
  RDS[(RDS Multi-AZ\nprivate subnets)]
  S3[S3 static assets]
  CW[CloudWatch\nmetrics & alarms]

  Users -->|HTTPS/HTTP| ALB
  ALB --> ASG
  ASG --> RDS
  Users -.->|static| S3
  ALB --> CW
  ASG --> CW
  RDS --> CW
```

## Network (Phase 1 — implemented in Terraform)

| Tier | Subnets | Purpose |
|------|---------|---------|
| Public | 2 AZs | ALB, NAT gateway |
| Private | 2 AZs | EC2 (ASG), RDS |

- **VPC CIDR:** default `10.0.0.0/16` (override in `terraform.tfvars`)
- **NAT:** single NAT gateway in first public subnet (lab cost control)

## Security groups (Phase 2)

| SG | Inbound | Outbound |
|----|---------|----------|
| ALB | 80/443 from `0.0.0.0/0` | app port to app SG |
| App (EC2) | app port from ALB SG | 443 to internet (via NAT), DB port to RDS SG |
| RDS | DB port from app SG | none required for basic lab |

## Implementation phases

| Phase | Module | Status |
|-------|--------|--------|
| 1 | `modules/vpc` | **Scaffold — ready to plan/apply** |
| 2 | `modules/alb`, `modules/asg` | Stub (README only) |
| 3 | `modules/rds` | Stub |
| 4 | `modules/s3`, `modules/cloudwatch` | Stub |
| 5 | Remote state (S3 + DynamoDB lock) | Commented in `versions.tf` |

## Relationship to Project 1

[Project 1](../project-1-ansible-lab/README.md) proves **Ansible + Linux automation** on VirtualBox.  
Project 2 moves the same discipline to **AWS + Terraform + observability**.
