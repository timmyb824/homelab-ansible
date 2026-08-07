# proxmox_node

Automates the manual setup steps performed on every new Proxmox VE node
(sysctl tuning, packages, journald/logrotate, limits, vzdump, haveged, Lynis).

## What it does

- **Kernel panic tuning** — `kernel.panic=10`, `kernel.panic_on_oops=1` (`/etc/sysctl.d/99-kernelpanic.conf`)
- **Packages** — common utilities plus `haveged` (enabled with `DAEMON_ARGS="-w 1024"`) and `git`
- **APT** — disables translation downloads, forces IPv4
- **inotify/limits** — `fs.inotify.max_user_watches=4194304`, `* soft nofile 1048576` (reboot required for nofile)
- **journald** — `SystemMaxUse=64M`
- **Memory** — swappiness/dirty ratios/overcommit in `99-memory.conf`; `vm.compaction_proactiveness` only when the kernel supports it
- **logrotate** — ProxMenux-style `/etc/logrotate.conf` (original backed up via `backup: true`)
- **Network** — `99-network-performance.conf` hardening/performance sysctls, TCP BBR + Fast Open (module loaded now and at boot), per-interface `txqueuelen` via udev rule
- **vzdump** — `bwlimit: 0`, `ionice: 5`
- **Lynis** — clones to `/opt/lynis`, installs `/usr/local/bin/lynis` wrapper; audit only runs when `proxmox_node_lynis_run_audit: true`

## Usage

```yaml
- hosts: proxmox
  become: true
  roles:
    - role: proxmox_node
      proxmox_node_txqueue_interfaces:
        - enp1s0
        - vmbr0
```

All values are overridable — see `defaults/main.yaml`. Run subsets with tags:
`packages`, `apt`, `sysctl`, `journald`, `logrotate`, `limits`, `network`, `vzdump`, `lynis`.

## Notes

- `net.ipv4.tcp_tw_reuse` is set to `0` (the manual notes contained both `1` and `0`; the last write won).
- Interfaces listed in `proxmox_node_txqueue_interfaces` that do not exist on the node are skipped for the immediate `ip link set`, but still written to the udev rule.
- Debian-based systems only (asserted).
