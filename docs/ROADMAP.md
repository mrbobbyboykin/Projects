# Project roadmap ↔ repo

## Weeks 1–2 — Foundation + lab setup

| Task | Repo / notes |
|------|----------------|
| Rebuild/clean RHEL VMs | Lab procedure (outside Git). |
| Static IP or DHCP reservations | Document IPs in `inventory/hosts.ini`. |
| Hostnames `Control-Node`, `App-Node` | Match `inventory_hostname` / inventory names. |
| SSH keys | See `docs/LAB-SETUP.md`. |
| Git + Ansible on control | README prerequisites. |
| **Deliverable:** passwordless SSH control → app | Verified with `ansible webservers -m ping`. |
| **Deliverable:** Git initialized | `git init` on Control-Node copy of this repo. |

## Weeks 3–4 — Automation phase

| Task | Repo |
|------|------|
| Install nginx/httpd, enable service | `roles/webserver/tasks/main.yml` |
| firewalld HTTP/HTTPS | `ansible.posix.firewalld` in same role |
| Variables | `group_vars`, `defaults/main.yml`, `web_stack` |
| Roles structure | `roles/common`, `roles/webserver` |
| Stretch: second/third app VM | Duplicate entries in `inventory/hosts.ini`, clone VM |
| **Deliverable:** one command | `ansible-playbook playbooks/site.yml` |

## Weeks 5–6 — Professional polish

| Task | Repo |
|------|------|
| Clean layout | Current tree under `inventory/`, `playbooks/`, `roles/` |
| README + architecture | `README.md` (Mermaid diagram) |
| Meaningful Git commits | Small commits per concern (inventory vs role vs docs). |
| Version tags | `v1.0.0`, `v2.0.0` per README |
| **Scenario:** “Provision 3 web servers under ~2 minutes” | `time ansible-playbook …` after warm cache; `forks` in `ansible.cfg` |
