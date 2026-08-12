# Projects — Cloud & Platform Engineering Portfolio

## Projects

| # | Folder | Status | Summary |
|---|--------|--------|---------|
| 1 | [project-1-ansible-lab](project-1-ansible-lab/) | **Complete** | Built a multi-node RHEL 9 web lab with Ansible, covering baseline hardening, web server deployment, firewall configuration, rolling patching, and read-only troubleshooting. The stack was designed as reusable roles and playbooks, deployed from a control node over SSH, verified with health checks and screenshots, and managed through a Git-based workflow. |
| 2 | [project-2-aws-infrastructure](project-2-aws-infrastructure/) | **Complete** (Phases 1–5) | Built and documented a multi-tier AWS environment with Terraform, covering networking, compute, database, storage, monitoring, and remote state. The stack was designed as reusable modules, deployed in phases, verified in the AWS Console, and torn down when idle to control lab cost. |
| 3 | [project-3-static-site](project-3-static-site/) | **Complete** | Built and documented a serverless static site with Terraform, covering private S3 hosting, CloudFront delivery, and a DynamoDB visitor counter via Lambda and API Gateway. The stack was modular, verified live over HTTPS, and kept available as a low-cost portfolio demo with budget alerts. |
| 4 | [project-4-cicd](project-4-cicd/) | **Complete** | Built an AWS CI/CD pipeline with CodePipeline and CodeBuild that deploys the Project 3 static site to S3 and invalidates CloudFront on every push to main. GitHub is connected via CodeStar Connections; pipeline success was verified with live site updates. |
| 5 | [project-5-azure-static-site](project-5-azure-static-site/) | **In progress** | Azure mirror of Project 3: Storage static website + Azure Function visitor counter + Table Storage (Terraform). |

## Quick links

- [Project 1 - What was Implemented](https://github.com/mrbobbyboykin/Projects/blob/main/project-1-ansible-lab/docs/Project%201%20-%20What%20was%20Implemented.docx)
- [Project 2 - What was Implemented](https://github.com/mrbobbyboykin/Projects/blob/main/project-2-aws-infrastructure/docs/Project%202%20-%20What%20was%20Implemented.docx)
- [Project 3 - What was Implemented](https://github.com/mrbobbyboykin/Projects/blob/main/project-3-static-site/docs/Project%203%20%E2%80%93%20What%20was%20Implemented.docx)
- [Project 4 - What was Implemented](https://github.com/mrbobbyboykin/Projects/blob/main/project-4-cicd/docs/Project%204%20%E2%80%93%20What%20was%20Implemented.docx)

## Repository layout

```
Projects/
├── README.md                          ← you are here
├── project-1-ansible-lab/             ← Ansible / RHEL automation lab
├── project-2-aws-infrastructure/      ← AWS + Terraform multi-tier lab
├── project-3-static-site/             ← S3 + CloudFront + DynamoDB counter
├── project-4-cicd/                    ← CodePipeline + CodeBuild → Project 3
└── project-5-azure-static-site/       ← Azure Storage + Function counter
```

## License

See [project-1-ansible-lab/LICENSE](project-1-ansible-lab/LICENSE) (MIT).
