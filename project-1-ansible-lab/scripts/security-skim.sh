#!/usr/bin/env bash
# Local security skim: failed logins + SELinux mode / recent AVC hints.
# Run on a RHEL node, e.g.:
#   sudo ./scripts/security-skim.sh
set -euo pipefail

echo "=== SELinux ==="
if command -v getenforce >/dev/null 2>&1; then
  getenforce
  sestatus 2>/dev/null | head -n 8 || true
else
  echo "getenforce not found"
fi
echo

echo "=== Failed SSH / auth (last matches) ==="
if [[ -f /var/log/secure ]]; then
  grep -E 'Failed password|Invalid user|authentication failure' /var/log/secure | tail -n 20 || echo "(no matches)"
elif command -v journalctl >/dev/null 2>&1; then
  journalctl -u sshd --no-pager -n 50 | grep -Ei 'fail|invalid|error' || echo "(no matches)"
else
  echo "No /var/log/secure or journalctl"
fi
echo

echo "=== Recent SELinux AVC / setroubleshoot ==="
if command -v ausearch >/dev/null 2>&1; then
  ausearch -m avc -ts recent 2>/dev/null | tail -n 25 || echo "(no recent AVC denials)"
else
  journalctl -t setroubleshoot --no-pager -n 20 2>/dev/null || echo "ausearch not installed; no setroubleshoot hits"
fi
echo

echo "=== Listening TCP/UDP (first lines) ==="
ss -tulpn 2>/dev/null | head -n 20 || netstat -tulpn 2>/dev/null | head -n 20 || true
