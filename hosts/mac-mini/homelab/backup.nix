# The first backup repo: an append-only rest-server on the Mac's internal disk.
# The guest's restic pushes to it nightly at host.lima.internal:8000; a broken
# or compromised guest can add snapshots but never delete them. Prune and check
# run here, as root, directly on the repo folder.
{ config, pkgs, ... }:
let
  root = "/var/lib/homelab-backup/restic";
  # --private-repos: each htpasswd user gets only the repo named after it.
  repo = "${root}/homelab";
  secrets = config.sops.secrets;

  restic =
    cmd:
    [
      "${pkgs.restic}/bin/restic"
      "--repo"
      repo
      "--password-file"
      secrets."restic/password".path
      # launchd gives root no HOME.
      "--cache-dir"
      "/var/lib/homelab-backup/cache"
    ]
    ++ cmd;
in
{
  sops.secrets."restic/password" = { };
  sops.secrets."restic/htpasswd" = { };

  system.activationScripts.postActivation.text = ''
    install -d -m 700 /var/lib/homelab-backup ${root}
  '';

  launchd.daemons.rest-server.serviceConfig = {
    ProgramArguments = [
      "${pkgs.restic-rest-server}/bin/rest-server"
      "--path"
      root
      "--listen"
      "127.0.0.1:8000"
      "--append-only"
      "--private-repos"
      "--htpasswd-file"
      secrets."restic/htpasswd".path
    ];
    RunAtLoad = true;
    # Also covers the boot race with sops-install-secrets.
    KeepAlive = true;
    StandardOutPath = "/var/log/homelab/rest-server.log";
    StandardErrorPath = "/var/log/homelab/rest-server.log";
  };

  # Sunday 05:00, after the guest's 03:00 backup.
  launchd.daemons.restic-prune.serviceConfig = {
    ProgramArguments = restic [
      "forget"
      "--prune"
      "--keep-daily"
      "7"
      "--keep-weekly"
      "4"
      "--keep-monthly"
      "12"
    ];
    StartCalendarInterval = [
      {
        Weekday = 0;
        Hour = 5;
        Minute = 0;
      }
    ];
    StandardOutPath = "/var/log/homelab/prune.log";
    StandardErrorPath = "/var/log/homelab/prune.log";
  };

  # A tenth of the data, read back and verified, once a month.
  launchd.daemons.restic-check.serviceConfig = {
    ProgramArguments = restic [
      "check"
      "--read-data-subset=10%"
    ];
    StartCalendarInterval = [
      {
        Day = 1;
        Hour = 6;
        Minute = 0;
      }
    ];
    StandardOutPath = "/var/log/homelab/check.log";
    StandardErrorPath = "/var/log/homelab/check.log";
  };
}
