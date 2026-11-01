# Restoring Immich

The rules: move data aside, never delete it. Restore from the restic repo
only. Verify before calling it done. This needs a go-ahead in the session
(see `AGENTS.md`).

## A. Immich data lost or bad, the VM is fine

This is the drill that gated the first real upload. It was first run on
2026-11-01 with 246 items (2 Takeout albums) and passed: assets, albums,
checksums and sha256 identical, every thumbnail regenerated. Repeat it yearly.

1. Stop the group:
   ```sh
   ssh homelab
   sudo systemctl stop homelab-photos.target
   ```
2. Move the data aside:
   ```sh
   sudo mv /mnt/t7/immich /mnt/t7/immich.pre-restore-$(date +%F)
   sudo mv /mnt/t7/backups/db/immich /mnt/t7/backups/db/immich.pre-restore-$(date +%F)
   sudo systemctl start postgresql
   sudo -u postgres psql -c 'ALTER DATABASE immich RENAME TO immich_pre_restore'
   ```
3. Restore the files:
   ```sh
   sudo restic-homelab snapshots
   sudo restic-homelab restore <id> --target / --include /mnt/t7/immich --include /mnt/t7/backups/db/immich
   ```
   It ends with `Fatal: There were 1 errors`: `lchown /mnt/t7: operation
   not permitted`. That's the share's root, and virtiofs refuses chown. It is
   harmless; every file is restored.
4. Recreate an empty `immich` DB with its extensions, then load the newest
   dump. Immich's dump is a `pg_dump` of the `immich` DB alone, with no
   `CREATE DATABASE`, so `postgresql-setup` creates the DB first:
   ```sh
   sudo systemctl restart postgresql-setup.service
   sudo -u postgres psql -d immich -Atc "SELECT extname FROM pg_extension ORDER BY 1"
   # cube earthdistance pg_trgm plpgsql unaccent uuid-ossp vchord vector

   f=$(ls -t /mnt/t7/backups/db/immich/*.sql.gz | head -1)
   gunzip -c "$f" |
     sed "s/SELECT pg_catalog.set_config('search_path', '', false);/SELECT pg_catalog.set_config('search_path', 'public, pg_catalog', true);/g" |
     sudo -u postgres psql -q -v ON_ERROR_STOP=1 -d immich
   sudo -u postgres psql -d immich -Atc "SELECT count(*) FROM asset"
   ```
   Encoded video and thumbnails aren't backed up, but their `.immich` folder
   markers are, so Immich's folder check passes. If Immich ever refuses to
   start with `Failed to read: "<UPLOAD_LOCATION>/<folder>/.immich"`, a
   folder lost its marker: `touch` it, if its contents were lost on purpose.
5. Start the group and verify:
   ```sh
   sudo systemctl start homelab-photos.target
   homelab-guest-check
   ```
   - The asset count matches (Administration → Server stats, or the API).
   - The sha256 of a sample of originals matches the moved-aside copy.
   - Albums and metadata are intact.
   - Thumbs and encodes regenerate after running the "missing" jobs
     (Administration → Jobs). To prove it, run Generate Thumbnails → All once.
6. After a week with no problems, delete the `pre-restore` copies and the
   `immich_pre_restore` DB.

## B. VM disk lost

This is written down, not drilled.

1. Get the repo password and the rest-server password from the password
   manager or the paper copy.
2. Rebuild the VM from the base image (operator.md, Bootstrap 1–3).
3. In the fresh guest, restore its old host key, so sops decrypts again
   without re-keying:
   ```sh
   nix shell nixpkgs#restic
   export RESTIC_REST_USERNAME=homelab RESTIC_REST_PASSWORD=<rest password>
   restic -r rest:http://host.lima.internal:8000/homelab/ snapshots
   sudo -E restic -r rest:http://host.lima.internal:8000/homelab/ restore latest --target / \
     --include /etc/ssh/ssh_host_ed25519_key --include /etc/ssh/ssh_host_ed25519_key.pub \
     --include /var/lib/tailscale/tailscaled.state
   sudo systemctl restart sshd
   ```
   The Tailscale state brings the guest back as the same tailnet node, with
   the same `100.x` address, so the DNS record stays right. The auth key in
   sops is single-use and long spent. Without the state, make a new tagged
   key in the admin console, put it in `homelab.yaml`, and delete the old
   `homelab` machine there.
   Then remove the old entry with `ssh-keygen -R homelab` on the Mac.
4. Run `rebuild-homelab`.
5. Follow scenario A from step 3 (there's nothing to move aside).
