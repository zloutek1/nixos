# Immich, with its Postgres and Redis. The media path is fixed at
# /var/lib/immich and never changes: the T7 folders are bound into it inside
# the service, so the paths Immich stores in its DB never mention /mnt/t7.
# Thumbnails stay on the VM disk; originals, profile, encoded video and the
# nightly DB dump go on the T7.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homelab.services.immich;
  media = config.services.immich.mediaLocation;
  t7 = "/mnt/t7";
  onT7 = {
    library = "immich/library";
    upload = "immich/upload";
    profile = "immich/profile";
    encoded-video = "immich/encoded-video";
    backups = "backups/db/immich";
  };
in
{
  options.homelab.services.immich.enable = lib.mkEnableOption "Immich";

  config = lib.mkIf cfg.enable {
    services.immich = {
      enable = true;
      # 26.05's Immich 2.x is end-of-life and marked insecure; 3.x is on
      # unstable. Back to the release's own once 26.11 ships 3.x.
      package = pkgs.unstable.immich;
      mediaLocation = "/var/lib/immich";
      host = "127.0.0.1";
      # Settings set here are read-only in the admin UI.
      settings = {
        server.externalDomain = "https://photos.zloutek1.com";
        newVersionCheck.enabled = false;
        # Originals land in a tree that can be restored without Immich.
        storageTemplate = {
          enabled = true;
          hashVerificationEnabled = true;
          template = "{{y}}/{{y}}-{{MM}}-{{dd}}/{{filename}}";
        };
        # Into backups/, which restic picks up at 03:00.
        backup.database = {
          enabled = true;
          cronExpression = "0 02 * * *";
          keepLastAmount = 14;
        };
      };
    };
    services.postgresql.package = pkgs.postgresql_17;

    homelab.t7.dirs = lib.attrValues onT7;
    homelab.t7.units = [ "immich-server" ];
    systemd.services.immich-server.serviceConfig.BindPaths = lib.mapAttrsToList (
      dir: src: "${t7}/${src}:${media}/${dir}"
    ) onT7;

    services.restic.backups.homelab.paths = [
      "${t7}/immich/library"
      "${t7}/immich/upload"
      "${t7}/immich/profile"
      # Not their contents (they regenerate), only the folder-check markers:
      # Immich refuses to start if a folder it has checked lost its .immich.
      "${t7}/immich/encoded-video/.immich"
      "${media}/thumbs/.immich"
    ];

    homelab.checks.immich = "${pkgs.curl}/bin/curl -fsS http://127.0.0.1:2283/api/server/ping";
    homelab.checks.postgres = "${config.services.postgresql.package}/bin/pg_isready -q";
    homelab.checks."immich DB dump under 26 h old" = ''
      newest=$(ls -t ${t7}/${onT7.backups}/*.sql.gz 2>/dev/null | head -1)
      [ -n "$newest" ] && [ $(( $(date +%s) - $(stat -c %Y "$newest") )) -lt $((26 * 3600)) ]
    '';
  };
}
