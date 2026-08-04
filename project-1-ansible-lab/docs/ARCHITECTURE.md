# Project 1 — Architecture

Multi-node RHEL Ansible lab on VirtualBox.

## High-level flow

```mermaid
flowchart LR
  Win[Windows 11 host]
  GH[GitHub]
  CN[Control-Node\nVirtualBox]
  A1[App-Node1\nnginx :80]
  A2[App-Node2\nnginx :80]

  Win -->|git push| GH
  GH -->|git pull| CN
  CN -->|SSH :22 ansible| A1
  CN -->|SSH :22 ansible| A2
  Win -->|HTTP :80| A1
  Win -->|HTTP :80| A2
```

Lab diagram (PNG): [Ansible Lab Architecture.png](Ansible%20Lab%20Architecture.png)

## Roles

| Role | Purpose |
|------|---------|
| `common` | Packages, chrony/timezone, ansible user/sudo, SSH hardening, SELinux, logrotate |
| `webserver` | nginx/httpd, firewalld, templated page, SELinux contexts |

## Playbooks

| Playbook | Purpose |
|----------|---------|
| `site.yml` | Apply `common` + `webserver` |
| `patch.yml` | Rolling `dnf` updates (`serial: 1`) |
| `troubleshoot.yml` | Read-only health / security snapshot |
