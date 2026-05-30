# Lab foundation (Weeks 1–2)

These steps are performed **once per VM** (or via snapshots/golden images). Paths/commands assume **RHEL 8/9**.

## Naming & networking

1. Set hostnames:

```bash
# On control VM
sudo hostnamectl set-hostname Control-Node

# On each app VM
sudo hostnamectl set-hostname App-Node   # or App-Node-02, App-Node-03
```

1. **Static IP or DHCP**
  - **Static:** edit connection via `nmcli` / NM keyfiles under `/etc/NetworkManager/system-connections/`.
  - **DHCP reservation:** pin MAC addresses in VirtualBox host-only NAT/router so IPs stay stable enough for Ansible.

Document each VM’s IP in `inventory/hosts.ini`.

## Dedicated Ansible user (recommended)

On **each app node**:

```bash
sudo useradd -m -s /bin/bash ansible
sudo mkdir -p ~ansible/.ssh
sudo chmod 700 ~ansible/.ssh
```

On **Control-Node**, copy your public key:

```bash
ssh-copy-id ansible@<APP_NODE_IP>
```

Grant passwordless sudo for automation (tighten later with Ansible-managed sudoers drop-in):

```bash
echo 'ansible ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/ansible
sudo chmod 440 /etc/sudoers.d/ansible
```

## Control-Node packages

```bash
sudo dnf install -y git ansible-core
git clone https://github.com/mrbobbyboykin/Projects.git Ansible-Lab
cd Ansible-Lab/project-1-ansible-lab
ansible-galaxy collection install -r collections/requirements.yml
```

## Deliverable checks

- `ssh ansible@<APP_NODE_IP>` works **without a password** (key only).
- `ansible webservers -m ping` succeeds from the project directory on Control-Node.
- This directory is a Git repo (`git init` / `git remote add` as needed).

