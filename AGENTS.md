# nix-config

One flake for every host: `yoga` (NixOS laptop), `mac-mini` (nix-darwin home
server) and `homelab` (the NixOS guest VM on the Mac mini that runs every
service).

- Layout: `hosts/<host>/`, `users/tomas/`, `modules/{common,darwin,nixos}/`.
  `hosts/default.nix` builds every host.
- Checks: `nix flake check` (or `--no-build`). Add
  `--override-input secrets path:./tests/secrets` on a machine without
  access to the private `nix-secrets` repo. Format with `nix fmt`.
- The homelab: read [docs/homelab/operator.md](docs/homelab/operator.md)
  first.

## Standing rules for the homelab

Reach it the way the operator does: `ssh mac-mini 'ssh homelab sudo systemctl …'`.

**Free to do:** status, logs, `homelab-check`, and start, stop or restart of
a service or group.

**Needs the user's go-ahead in the session:**
- deploys: `rebuild`, `rebuild-homelab`;
- `homelab-reboot`;
- restores;
- anything that touches `/mnt/t7` data, the restic repo or secrets.

These are rules, not enforcement: the guest's sudo asks for no password.
