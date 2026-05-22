# RHEL Ansible Web Lab

Portfolio-oriented automation lab: **Ansible control host → multiple RHEL app nodes**, one playbook installs and enables **nginx or httpd**, manages **firewalld**, and drops a small templated homepage.

## Architecture

![Ansible lab architecture](docs/Ansible%20Lab%20Architecture.png)

- **Windows 11 host**: developer workstation pushes playbooks to **GitHub** (`HTTPS git push`); browser tests **HTTP :80** on each app node.
- **Control-Node** (VirtualBox): pulls the repo (`HTTPS git pull`), runs `ansible-playbook playbooks/site.yml`, and connects to app nodes over **SSH :22** (`ansible` user + key).
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

From the repository root on **Control-Node**:

```bash
ansible-playbook playbooks/site.yml
```

Or:

```bash
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

```
├── ansible.cfg
├── collections/requirements.yml
├── docs/
├── inventory/
│   ├── hosts.ini
│   └── group_vars/webservers.yml
├── playbooks/
│   └── site.yml
├── scripts/
│   └── deploy.sh
└── roles/
    ├── common/
    └── webserver/
```

Initialize Git on **Control-Node** (first meaningful commit after you personalize inventory):

```bash
git init
git add .
git commit -m "feat: ansible scaffold for multi-node web stack"
```

## Versioning (Git)

