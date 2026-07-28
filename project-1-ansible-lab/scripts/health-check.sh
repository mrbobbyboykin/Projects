#!/usr/bin/env bash
# Local host health snapshot (CPU, memory, disk, load).
# Run on a RHEL node (Control-Node or App-Node), e.g.:
#   sudo ./scripts/health-check.sh
set -euo pipefail

echo "=== Host ==="
hostnamectl --static 2>/dev/null || hostname
uptime
echo

echo "=== CPU (top processes) ==="
ps -eo pid,user,pcpu,pmem,comm --sort=-pcpu | head -n 8
echo

echo "=== Memory ==="
free -m
echo

echo "=== Disk ==="
df -hT -x tmpfs -x devtmpfs
echo

echo "=== Load / pressure (if available) ==="
if [[ -r /proc/loadavg ]]; then
  echo "loadavg: $(cat /proc/loadavg)"
fi
if [[ -d /proc/pressure ]]; then
  echo "cpu pressure:  $(head -n 1 /proc/pressure/cpu 2>/dev/null || true)"
  echo "mem pressure:  $(head -n 1 /proc/pressure/memory 2>/dev/null || true)"
  echo "io pressure:   $(head -n 1 /proc/pressure/io 2>/dev/null || true)"
fi
echo

echo "=== Block devices ==="
lsblk -o NAME,SIZE,TYPE,MOUNTPOINTS 2>/dev/null || lsblk
