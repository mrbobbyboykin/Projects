# Projects — Cloud & Platform Engineering Portfolio

Monorepo for hands-on labs and infrastructure projects. Each project lives in its own folder with a dedicated README, architecture diagram, and evidence (screenshots) where applicable.

## Projects

| # | Folder | Status | Summary |
|---|--------|--------|---------|
| 1 | [project-1-ansible-lab](project-1-ansible-lab/) | **Complete** | Built a multi-node RHEL 9 web lab with Ansible, covering baseline hardening, web server deployment, firewall configuration, rolling patching, and read-only troubleshooting. The stack was designed as reusable roles and playbooks, deployed from a control node over SSH, verified with health checks and screenshots, and managed through a Git-based workflow. |
| 2 | [project-2-aws-infrastructure](project-2-aws-infrastructure/) | **Complete** (Phases 1–5) | Built and documented a multi-tier AWS environment with Terraform, covering networking, compute, database, storage, monitoring, and remote state. The stack was designed as reusable modules, deployed in phases, verified in the AWS Console, and torn down when idle to control lab cost. |
| 3 | *(planned)* | Next | S3 static site + CloudFront + DynamoDB visitor counter. |

## Quick links (recruiters)

- **Project 1 (Ansible lab):** [project-1-ansible-lab/README.md](project-1-ansible-lab/README.md)
- **Project 1 architecture diagram:** [project-1-ansible-lab/docs/Ansible Lab Architecture.png](project-1-ansible-lab/docs/Ansible%20Lab%20Architecture.png)
- **Project 1 milestone screenshots:** [project-1-ansible-lab/docs/](project-1-ansible-lab/docs/) (see `Milestone Screenshots` if present)
- **Project 2 (AWS / Terraform):** [project-2-aws-infrastructure/README.md](project-2-aws-infrastructure/README.md)

## Repository layout

```
Projects/
├── README.md                          ← you are here
├── project-1-ansible-lab/             ← Ansible / RHEL automation lab
└── project-2-aws-infrastructure/      ← AWS + Terraform
```

## How I work

- **Windows:** edit, commit, and push from the `Projects-git` clone.
- **Linux control host:** `git pull`, then run automation from the relevant project folder (e.g. `project-1-ansible-lab/`).

## License

See [project-1-ansible-lab/LICENSE](project-1-ansible-lab/LICENSE) (MIT).
