# Project 1 — RHEL Ansible Web Lab

[← Back to portfolio index](../README.md)

Portfolio-oriented automation lab: **Ansible control host → multiple RHEL app nodes**, one playbook installs and enables **nginx or httpd**, manages **firewalld**, and drops a templated homepage.

## Architecture

![Ansible lab architecture](docs/Ansible%20Lab%20Architecture.png)

- **Windows 11 host**: developer workstation pushes playbooks to **GitHub** (`HTTPS git push`); browser tests **HTTP :80** on each app node.
- **Control-Node** (VirtualBox): pulls the monorepo (`HTTPS git pull`), runs playbooks from **`project-1-ansible-lab/`**, and connects to app nodes over **SSH :22** (`ansible` user + key).
- **App-Node1** and **App-Node2**: `[webservers]` targets running **nginx :80**, with **firewalld** (`http`/`https`) and a templated landing page per host.

## Prerequisites

- Oracle VirtualBox on Windows 11; **three RHEL VMs** (Control-Node + App-Node1 + App-Node2).
- SSH key-based auth from Control-Node to each app node (see `docs/LAB-SETUP.md`).
- On **Control-Node**:

```bash
sudo dnf install -y git ansible-core
ansible-galaxy collection install -r collections/requirements.yml
```

## Quick start (one-command deploy)

On **Control-Node**, from the **project folder** (after `git pull` at repo root):

```bash
cd ~/Ansible-Lab/project-1-ansible-lab
ansible-galaxy collection install -r collections/requirements.yml
ansible-playbook playbooks/site.yml
```

Or:

```bash
cd ~/Ansible-Lab/project-1-ansible-lab
chmod +x scripts/deploy.sh
./scripts/deploy.sh
```

Smoke test from your browser or `curl`:

```bash
curl -s http://192.168.1.160 | head
curl -s http://192.168.1.161 | head
```

(Use the IPs from your `inventory/hosts.ini`.)

### Parallel timing (two app nodes)

Use enough forks (already set in `ansible.cfg`) and run:

```bash
time ansible-playbook playbooks/site.yml
```

**Note:** First run is slower while `dnf` caches populate; subsequent runs are what you quote on a resume (repeat runs after snapshots).

## Configuration

| Item | Location |
|------|-----------|
| Targets & IPs | `inventory/hosts.ini` |
| Shared vars (e.g. nginx/httpd) | `inventory/group_vars/webservers.yml` |
| Role defaults | `roles/webserver/defaults/main.yml` |

Switch stacks per group or host by setting `web_stack` to `nginx` or `httpd`.

## Repository layout

This project lives under **`project-1-ansible-lab/`** in the [Projects](https://github.com/mrbobbyboykin/Projects) monorepo.

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
│   └── site.yml                # Main entry: common + webserver roles
├── roles/
│   ├── common/                 # Baseline packages for managed nodes
│   └── webserver/              # nginx/httpd, firewalld, index template
├── scripts/
│   └── deploy.sh               # Wrapper for ansible-playbook
├── LICENSE
└── README.md
```

**Git workflow:** edit and push from **Windows** (`Projects-git` clone). On **Control-Node**, `git pull` at repo root, then `cd project-1-ansible-lab` and run Ansible.

