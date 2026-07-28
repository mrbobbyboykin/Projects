#!/usr/bin/env bash

# This script is used to deploy the application using ansible.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
exec ansible-playbook playbooks/site.yml "$@"
