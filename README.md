# Projects — Cloud & Platform Engineering Portfolio

Monorepo for hands-on labs and infrastructure projects. Each project lives in its own folder with a dedicated README, architecture diagram, and evidence (screenshots) where applicable.

## Projects

| # | Folder | Status | Summary |
|---|--------|--------|---------|
| 1 | [project-1-ansible-lab](project-1-ansible-lab/) | **Complete** | Multi-node RHEL 9 web tier automated with Ansible (Control-Node + App-Node1/2, nginx, firewalld, Git workflow). |
| 2 | [project-2-aws-infrastructure](project-2-aws-infrastructure/) | **In progress** | AWS VPC foundation in Terraform; ALB, ASG, RDS, S3, CloudWatch modules stubbed. |

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
└── project-2-aws-infrastructure/      ← AWS + Terraform (in progress)
```

## How I work

- **Windows:** edit, commit, and push from the `Projects-git` clone.
- **Linux control host:** `git pull`, then run automation from the relevant project folder (e.g. `project-1-ansible-lab/`).

## License

See [project-1-ansible-lab/LICENSE](project-1-ansible-lab/LICENSE) (MIT).
