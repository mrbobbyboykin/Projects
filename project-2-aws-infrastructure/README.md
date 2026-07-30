# Project 2 — AWS Cloud Infrastructure

[← Back to portfolio index](../README.md)

## Repository layout

```
project-2-aws-infrastructure/
├── docs/
│   ├── ARCHITECTURE.md              # Target diagram & phase plan
│   ├── Milestone-Screenshots/       # VPC, ALB, ASG, console evidence
│   └── What is Implemented.docx
└── terraform/
    ├── main.tf                      # Composes modules
    ├── variables.tf
    ├── outputs.tf
    ├── providers.tf
    ├── versions.tf
    ├── terraform.tfvars.example
    └── modules/
        ├── vpc/                     # Phase 1 — multi-AZ VPC
        ├── alb/                     # Phase 2 — Application Load Balancer
        ├── asg/                     # Phase 2 — Auto Scaling Group (nginx)
        ├── rds/                     # Phase 3 stub
        ├── s3/                      # Phase 4 stub
        └── cloudwatch/              # Phase 4 stub
```

## Architecture

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the full diagram and security-group plan.

- **Phase 1 (done):** Multi-AZ VPC with public/private subnets, Internet Gateway, and route tables (Terraform).
- **Phase 2 (done):** Public Application Load Balancer, target group, security groups, and Auto Scaling Group (Amazon Linux + nginx).
- **Planned:** RDS Multi-AZ, S3 static assets, and CloudWatch dashboards/alarms.
- **Cost discipline:** NAT off by default for the lab; tear down with `terraform destroy` when idle. Deploy steps live in [`terraform/README.md`](terraform/README.md).
