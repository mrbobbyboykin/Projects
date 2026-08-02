# Project 3 — Static Site + CloudFront + Visitor Counter

[← Back to portfolio index](../README.md)

## Repository layout

```
project-3-static-site/
├── docs/
│   └── ARCHITECTURE.md              # Diagram & phase plan
├── site/                            # Static HTML/CSS/JS uploaded to S3
└── terraform/
    ├── main.tf                      # Composes modules
    ├── variables.tf
    ├── outputs.tf
    ├── providers.tf
    ├── versions.tf
    ├── backend.hcl.example          # Reuses Project 2 state bucket (new key)
    ├── terraform.tfvars.example
    ├── lambda/visitor_counter/      # Python Lambda source
    └── modules/
        ├── s3_site/                 # Private origin bucket + objects
        ├── cloudfront/              # CDN + OAC (+ /api/* to API Gateway)
        ├── dynamodb/                # Visitor counter table
        └── api/                     # HTTP API + Lambda
```

## Architecture

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

- **Phase 1:** Private S3 origin + CloudFront (OAC) serving the static site.
- **Phase 2:** DynamoDB visitor counter + Lambda + API Gateway; CloudFront `/api/*` route.
- **Phase 3:** Wire the UI, capture screenshots, destroy when idle.

**Cost discipline:** very cheap when idle; `terraform destroy` the Project 3 stack when done. Keep the Project 2 **bootstrap** remote-state resources. Deploy steps: [`terraform/README.md`](terraform/README.md).
