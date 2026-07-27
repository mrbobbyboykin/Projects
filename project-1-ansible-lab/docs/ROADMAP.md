# Project roadmap ↔ repo

## Weeks 1–2 — Foundation + lab setup

| Task | Repo / notes |
|------|----------------|
| Rebuild/clean RHEL VMs | Lab procedure (outside Git). |
| Static IP or DHCP reservations | Document IPs in `inventory/hosts.ini`. |
| Hostnames `Control-Node`, `App-Node1`, `App-Node2` | Match `inventory_hostname` / inventory names. |
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
| Stretch: third app VM | Add `App-Node3` in `inventory/hosts.ini`, clone VM |
| **Deliverable:** one command | `ansible-playbook playbooks/site.yml` |

## Weeks 5–6 — Professional polish

| Task | Repo |
|------|------|
| Clean layout | Current tree under `inventory/`, `playbooks/`, `roles/` |
| README + architecture | `README.md` (Mermaid diagram) |
| Meaningful Git commits | Small commits per concern (inventory vs role vs docs). |
| Version tags | `v1.0.0`, `v2.0.0` per README |
| **Scenario:** “Provision 2 web servers quickly” | `time ansible-playbook …` after warm cache; `forks` in `ansible.cfg` |

## Weeks 7+ — Linux admin automation (baseline)

| Task | Repo |
|------|------|
| Common packages + chrony/timezone | `roles/common/tasks/main.yml` |
| Admin user + sudoers.d | same (`lab_admin_user`) |
| Safe SSH drop-in (`sshd_config.d`) | `roles/common/templates/sshd_lab.conf.j2` |
| Rolling patch playbook | `playbooks/patch.yml` |
| Tags | `--tags common`, `--tags ssh`, etc. |
| **Deliverable:** baseline without breaking SSH | `ansible webservers -m ping` after `site.yml` |
| Stretch: disable password auth | `lab_ssh_password_authentication: false` after verifying keys |
| SELinux enforcing + tools | `roles/common/tasks/selinux.yml` |
| restorecon on web docroot | `roles/webserver/tasks/main.yml` |
| nginx logrotate drop-in | `roles/common/tasks/logrotate.yml` |
