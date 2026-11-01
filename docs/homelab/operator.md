# Homelab operator's guide

The Mac mini (`mac-mini`, nix-darwin) runs one NixOS VM, `homelab`, under Lima
VZ. Every service runs in the guest as a NixOS module. The Mac runs only
plumbing: the VM daemon, the T7 mount, a watchdog, the backup repo and the
commands below.

Admin is **LAN-only**. Nothing reaches the Mac from outside the house, and
the tailnet only lets people reach `homelab:443`. So every command here
assumes home Wi-Fi.

## Getting in

```sh
ssh mac-mini          # from the Yoga
ssh homelab           # from the Mac: 127.0.0.1:60022, tomas, passwordless sudo
```

`limactl shell` isn't used: `tomas` can't run the Full Disk Access copy of
limactl (`root:homelab 750`).

## Applying config

Both commands run from the Mac's `~/nix-config`. Edit there, or push from
the Yoga and `git pull`.

| What changed | Command |
|---|---|
| the Mac (`hosts/mac-mini/`) | `rebuild` (`sudo darwin-rebuild switch`) |
| the guest (`hosts/homelab/`, `modules/nixos/`) | `rebuild-homelab` |

`rebuild-homelab` evaluates on the Mac, then builds and switches on the guest
(`--build-host homelab`). `boot`, `test` and `--rollback` work the usual way:

```sh
nixos-rebuild switch --rollback --flake ~/nix-config#homelab --target-host homelab --sudo
```

The private `nix-secrets` input is fetched over SSH. root uses the Mac's host
key and `tomas` the `tomas@mac-mini` key, and both are read-only deploy keys
on the repo.

## Up, down, status, logs

In the guest:

```sh
systemctl status homelab-photos.target           # a Group
sudo systemctl stop|start homelab-photos.target  # stops/starts every service in it
sudo systemctl restart immich-server             # one service
systemctl --failed
journalctl -u immich-server -f
journalctl _SYSTEMD_SLICE=homelab-photos.slice   # a whole group's logs
systemd-cgtop                                    # RAM and CPU per group slice
```

A runtime stop doesn't survive a reboot. To turn something off for good,
disable it in its group or host and run `rebuild-homelab`.

| Group | Services |
|---|---|
| `homelab-edge` | `tailscaled`, `caddy` |
| `homelab-photos` | `immich-server`, `immich-machine-learning`, `redis-immich`, `postgresql` |

On the Mac (reading it takes sudo):

```sh
sudo launchctl print system/org.nixos.homelab-vm
sudo tail -f /var/log/homelab/vm.log          # limactl
sudo tail /var/log/homelab/watchdog.log
sudo tail /var/log/homelab/{rest-server,prune,check,mount-t7}.log
sudo ls ~homelab/lima/homelab/                 # ha.stderr.log, serial*.log
```

## Checks

`homelab-check` (on the Mac) prints one ✓/✗ line per check and exits
non-zero on any ✗. Run it after every macOS update, after a power cut, and
whenever something feels off.

- **Mac:** the T7 is mounted with `homelab/.t7-marker`, the VM daemon is
  running, limactl is on the firewall allow list, rest-server is listening,
  and there's 20 GiB free.
- **Guest:** it runs `homelab-guest-check` over SSH. That covers systemd
  with no failed units, the T7 marker, plus each service's own probe
  (`homelab.checks.<name>`). The probes are: Immich's ping, `pg_isready`,
  the DB dump under 26 h old, `tailscale status`, `photos.zloutek1.com`
  through Caddy on the tailnet address with the certificate's days left, and
  the last restic snapshot under 36 h old.

## Rebooting and macOS updates

Never reboot the Mac directly: that hard-kills the guest. Use:

```sh
homelab-reboot            # stop the VM cleanly, then reboot
homelab-reboot --update   # stop the VM, then install macOS updates and restart
```

Updates are never installed unattended. After the reboot:

1. Unlock FileVault over SSH: `ssh tomas@192.168.2.131`, type the password,
   and the connection dropping is success.
2. Wait about 2 minutes, then run `homelab-check`.

## The watchdog

`org.nixos.homelab-watchdog` (root, every 60 s) restarts the VM daemon when
launchd won't. A lost T7 kills the VM, but Lima's host agent stays up, so
`KeepAlive` never fires.

- **VM daemon not loaded** (booted out by `homelab-reboot`): it does nothing.
- **T7 gone:** it notes it and waits. When the T7 comes back, it restarts
  the VM.
- **No SSH banner from the guest 3 times in a row,** once the daemon has
  been up 5 min: it restarts the VM.
- At most one restart per 10 min.

It sends no alerts; alerting belongs to monitoring.

## Backups

The guest's `restic-backups-homelab` runs at 03:00 and pushes to the
append-only `rest-server` on the Mac (`127.0.0.1:8000`, repo
`/var/lib/homelab-backup/restic/homelab`). It backs up Immich's originals,
uploads and profile, every DB dump (`/mnt/t7/backups/db/`), and the guest's
SSH host key.

In the guest, `sudo restic-homelab snapshots` (and `restore`, `ls`, …) has
the repo and password already set.

| Job | Where | When |
|---|---|---|
| Immich DB dump (keeps 14) → `backups/db/immich` | guest | 02:00 |
| `restic backup` | guest | 03:00 |
| `restic forget --prune` (7 daily, 4 weekly, 12 monthly) | Mac, `restic-prune` | Sunday 05:00 |
| `restic check --read-data-subset=10%` | Mac, `restic-check` | 1st of the month, 06:00 |

The repo password is in both sops files, in Google Password Manager and on
paper, next to the admin age key. Restores: [restore-immich.md](restore-immich.md).

## Secrets

Secrets use sops-nix, with the files in the private `zloutek1/nix-secrets`
repo: `mac-mini.yaml` and `homelab.yaml`. Each is encrypted to its host's
SSH host key plus the admin age key on the Yoga.

```sh
sops homelab.yaml                     # in a nix-secrets checkout, on the Yoga
sops updatekeys homelab.yaml          # after a host key changes (.sops.yaml)
```

Then `nix flake update secrets` in `nix-config` and redeploy. The guest's
host key lives on the VM disk and in the restic backup, so a rebuilt guest
needs no re-keying if the key is restored first.

## Adding a service

1. Write `modules/nixos/services/<name>.nix` with
   `homelab.services.<name>.enable`. It wraps the upstream module and
   declares `homelab.checks.<name>`. Every file in `services/` and `groups/`
   is imported automatically.
2. Enable it in a group (`modules/nixos/groups/<group>.nix`). Add its units
   to that group's `units` list: that sets `wantedBy`, `partOf` and the slice.
3. Data:
   - state goes in `/var/lib/<name>`, on the VM disk;
   - user files go under `homelab.storage.files` (the host sets it to
     `/mnt/t7`), in `<name>/`: list the folders in `homelab.storage.dirs` and
     the units in `homelab.storage.units`, so they wait for the share and its
     marker. Never hard-code `/mnt/t7` in a module;
   - databases dump to `<storage.files>/backups/db/<name>/`;
   - add a budget line below.
4. Add its user-file paths to `services.restic.backups.homelab.paths`, under
   `lib.mkIf config.homelab.services.backup.enable`.
5. Put its secrets in `homelab.yaml` in `nix-secrets`.
6. Reach: give the module a `domain` option that adds
   `homelab.services.caddy.hosts.${domain}` (as Immich does), and set it
   in `hosts/homelab/default.nix`. Then add a DNS-only A record to the
   tailnet IP and a policy rule in `tailscale/policy.hujson`. Lima forwards
   nothing until phase 3.
7. Note its RAM against the 10 GiB.
8. Run `rebuild-homelab`, then `homelab-check`.

## Budgets

These are watched, not enforced.

| Where | Dataset | Budget |
|---|---|---|
| VM disk (80 GiB) | NixOS and the Nix store | 30 GiB |
| | Postgres | 5 GiB |
| | Immich thumbnails | 15 GiB |
| | Immich ML cache | 3 GiB |
| | journald | 2 GiB |
| T7 `homelab/` | Immich originals + profile | 150 GiB |
| | Immich encoded video | 40 GiB |
| | DB dumps | 5 GiB |
| Mac internal | restic repo | 200 GiB |
| VM memory | everything | 10 GiB, counted as spent |

## Bootstrap (once, or after losing the VM)

1. Build the base image on the Mac's linux-builder
   (`nix.linux-builder` in `hosts/mac-mini/homelab/default.nix`, with a
   60 GiB disk: the default 20 GiB fills up and leaves broken store paths):
   ```sh
   nix build ~/nix-config#nixosConfigurations.homelab.config.system.build.images.qemu-efi
   sudo install -o homelab -g homelab -m 640 result/*.qcow2 /var/lib/homelab/base-image.qcow2
   ```
2. Create the share and its marker: `mkdir -p /Volumes/T7/homelab && touch /Volumes/T7/homelab/.t7-marker`.
3. Run `rebuild` (it links the instance's `lima.yaml`), then
   `sudo launchctl kickstart -k system/org.nixos.homelab-vm`.
4. Get the new guest's age key with
   `ssh homelab cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age`. Put it
   in `.sops.yaml` in `nix-secrets`, run `sops updatekeys homelab.yaml`, push,
   then `nix flake update secrets` and `rebuild-homelab`. (When restoring
   from backup, restore the old host key instead: restore-immich.md, B.)
5. Turn the linux-builder off again and `rebuild`.
