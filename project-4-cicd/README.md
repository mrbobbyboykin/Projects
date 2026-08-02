# Project 4 — CI/CD for Static Site (CodePipeline + CodeBuild)

[← Back to portfolio index](../README.md)

## Repository layout

```
project-4-cicd/
├── docs/
│   └── ARCHITECTURE.md
├── buildspec.yml                    # Deploy steps run by CodeBuild
└── terraform/
    ├── main.tf                      # Pipeline + Build + IAM + artifacts
    ├── variables.tf
    ├── outputs.tf
    ├── providers.tf
    ├── versions.tf
    ├── backend.hcl.example
    └── terraform.tfvars.example
```

## What this does

On every push to `main` in [mrbobbyboykin/Projects](https://github.com/mrbobbyboykin/Projects):

1. **CodePipeline** pulls the repo (via GitHub CodeStar Connection)
2. **CodeBuild** syncs `project-3-static-site/site/` to the Project 3 S3 bucket
3. **CodeBuild** creates a CloudFront invalidation so visitors see the update

## Prerequisites

- Project 3 stack already applied (S3 site bucket + CloudFront distribution)
- AWS credentials (same account as Project 3)
- One-time GitHub authorization for the CodeStar Connection (see [`terraform/README.md`](terraform/README.md))

## Cost note

Expect roughly **~$1–5/month** for a lightly used pipeline (CodePipeline + short CodeBuild runs), on top of Project 3 hosting.
