# Immich, with its Postgres and Redis. The media path is fixed at
# /var/lib/immich and never changes: the folders under homelab.storage.files
# are bound into it inside the service, so the paths Immich stores in its DB
# never mention where the files really are. Thumbnails stay on the system disk;
# originals, profile, encoded video and the nightly DB dump go under `files`.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homelab.services.immich;
  media = config.services.immich.mediaLocation;
  inherit (config.homelab.storage) files;
  bound = {
    library = "immich/library";
    upload = "immich/upload";
    profile = "immich/profile";
    encoded-video = "immich/encoded-video";
    backups = "backups/db/immich";
  };
in
{
  options.homelab.services.immich = {
    enable = lib.mkEnableOption "Immich";
    domain = lib.mkOption {
      type = lib.types.str;
      example = "photos.example.com";
      description = "The HTTPS name Immich is served at, through Caddy.";
    };
  };

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
        server.externalDomain = "https://${cfg.domain}";
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

    homelab.services.caddy.hosts.${cfg.domain} = "127.0.0.1:2283";

    homelab.storage.dirs = lib.attrValues bound;
    homelab.storage.units = [ "immich-server" ];
    systemd.services.immich-server.serviceConfig.BindPaths = lib.mapAttrsToList (
      dir: src: "${files}/${src}:${media}/${dir}"
    ) bound;

    services.restic.backups.homelab.paths = lib.mkIf config.homelab.services.backup.enable [
      "${files}/immich/library"
      "${files}/immich/upload"
      "${files}/immich/profile"
      # Not their contents (they regenerate), only the folder-check markers:
      # Immich refuses to start if a folder it has checked lost its .immich.
      "${files}/immich/encoded-video/.immich"
      "${media}/thumbs/.immich"
    ];

    homelab.checks.immich = "${pkgs.curl}/bin/curl -fsS http://127.0.0.1:2283/api/server/ping";
    homelab.checks.postgres = "${config.services.postgresql.package}/bin/pg_isready -q";
    homelab.checks."immich DB dump under 26 h old" = ''
      find ${files}/${bound.backups} -name '*.sql.gz' -mmin -$((26 * 60)) | grep -q .
    '';
  };
}
