# Project 1 — RHEL Ansible Web Lab

[← Back to portfolio index](../README.md)

## Repository layout

```
project-1-ansible-lab/
├── ansible.cfg                 # Defaults: inventory path, roles, forks
├── collections/
│   └── requirements.yml        # ansible.posix (firewalld module)
├── docs/
│   ├── Ansible Lab Architecture.png
│   ├── LAB-SETUP.md            # VM, SSH, Git workflow
│   ├── ROADMAP.md              # Week-by-week lab milestones
│   └── Milestone Screenshots/  # Evidence for README / interviews
├── inventory/
│   ├── hosts.ini               # App-Node1, App-Node2 targets
│   └── group_vars/
│       └── webservers.yml      # Shared vars (e.g. web_stack: nginx)
├── playbooks/
│   ├── site.yml                # Main entry: common + webserver roles
│   ├── patch.yml               # Rolling dnf updates (serial: 1)
│   └── troubleshoot.yml        # Read-only health / security snapshot
├── roles/
│   ├── common/                 # Packages, chrony, user/sudo, SSH, SELinux, logrotate
│   └── webserver/              # nginx/httpd, firewalld, index template
├── scripts/
│   ├── deploy.sh               # Wrapper for site.yml
│   ├── troubleshoot.sh         # Wrapper for troubleshoot.yml
│   ├── health-check.sh         # Local CPU/mem/disk snapshot
│   └── security-skim.sh        # Local auth failures + SELinux skim
├── LICENSE
└── README.md
```

## Architecture

![Ansible lab architecture](docs/Ansible%20Lab%20Architecture.png)

- **Windows 11 host**: developer workstation pushes playbooks to **GitHub** (`HTTPS git push`); browser tests **HTTP :80** on each app node.
- **Control-Node** (VirtualBox): pulls the monorepo (`HTTPS git pull`), runs playbooks from **`project-1-ansible-lab/`**, and connects to app nodes over **SSH :22** (`ansible` user + key).
- **App-Node1** and **App-Node2**: `[webservers]` targets running **nginx :80**, with **firewalld** (`http`/`https`) and a templated landing page per host.
