# Nightly restic backup to the append-only rest-server on the Mac. Services add
# their user files to services.restic.backups.homelab.paths. Not backed up:
# what regenerates (thumbs, encoded video, ML cache), Postgres itself (its dumps
# are), and the VM disk (rebuilt from the flake). Prune and check run on the Mac.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homelab.services.backup;
  t7 = "/mnt/t7";
  secrets = config.sops.secrets;
in
{
  options.homelab.services.backup.enable = lib.mkEnableOption "the restic backup";

  config = lib.mkIf cfg.enable {
    services.restic.backups.homelab = {
      # --private-repos on the Mac: the rest user `homelab` owns /homelab/.
      repository = "rest:http://host.lima.internal:8000/homelab/";
      environmentFile = config.sops.templates."restic-homelab.env".path;
      passwordFile = secrets."restic/password".path;
      initialize = true;
      paths = [
        "${t7}/backups/db"
        # Its sops identity, so a rebuilt guest needs no re-keying.
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
      ];
      # After Immich's 02:00 dump.
      timerConfig = {
        OnCalendar = "03:00";
        Persistent = true;
      };
      # Fail loudly instead of backing up an empty mountpoint or a stale dump.
      backupPrepareCommand = ''
        test -e ${t7}/.t7-marker || { echo "no ${t7}/.t7-marker" >&2; exit 1; }
        newest=$(find ${t7}/backups/db -type f -mmin -$((26 * 60)) | head -1)
        test -n "$newest" || { echo "no DB dump under 26 h old in ${t7}/backups/db" >&2; exit 1; }
      '';
    };
    sops.secrets."restic/password" = { };
    sops.secrets."restic/rest-password" = { };
    sops.templates."restic-homelab.env".content = ''
      RESTIC_REST_USERNAME=homelab
      RESTIC_REST_PASSWORD=${config.sops.placeholder."restic/rest-password"}
    '';

    homelab.t7.dirs = [ "backups/db" ];
    homelab.t7.units = [ "restic-backups-homelab" ];

    homelab.checks."restic snapshot under 36 h old" = ''
      latest=$(restic-homelab snapshots --latest 1 --json | ${pkgs.jq}/bin/jq -r '.[-1].time // empty')
      [ -n "$latest" ] || { echo "no snapshots"; exit 1; }
      age=$(( ($(date +%s) - $(date -d "$latest" +%s)) / 3600 ))
      echo "$age h old"
      [ "$age" -lt 36 ]
    '';
  };
}
