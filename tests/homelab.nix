# Things the homelab guest must keep doing whatever else changes.
{ config, ... }:
let
  immich = config.systemd.services.immich-server;
in
{
  testGcKeepsTwoWeeks = {
    expr = config.nix.gc.options;
    expected = "--delete-older-than 14d";
  };
  testPhotosTargetExists = {
    expr = config.systemd.targets ? homelab-photos;
    expected = true;
  };
  testImmichPartOfPhotos = {
    expr = immich.partOf;
    expected = [ "homelab-photos.target" ];
  };
  # Immich stores these paths in its DB; moving data means moving a bind.
  testImmichMediaPathFixed = {
    expr = config.services.immich.mediaLocation;
    expected = "/var/lib/immich";
  };
  testImmichOriginalsOnT7 = {
    expr = builtins.elem "/mnt/t7/immich/library:/var/lib/immich/library" immich.serviceConfig.BindPaths;
    expected = true;
  };
  testImmichNeedsT7Marker = {
    expr = immich.unitConfig.ConditionPathExists;
    expected = "/mnt/t7/.t7-marker";
  };
  testImmichHasACheck = {
    expr = config.homelab.checks ? immich;
    expected = true;
  };
  testOriginalsBackedUp = {
    expr = builtins.elem "/mnt/t7/immich/library" config.services.restic.backups.homelab.paths;
    expected = true;
  };
  # Tailnet only: 443 is open on tailscale0 and nowhere else.
  testHttpsOnlyOnTailnet = {
    expr = {
      tailnet = config.networking.firewall.interfaces.tailscale0.allowedTCPPorts;
      everywhere = config.networking.firewall.allowedTCPPorts;
    };
    expected = {
      tailnet = [ 443 ];
      everywhere = [ 22 ];
    };
  };
  testSshKeyOnly = {
    expr = config.services.openssh.settings.PasswordAuthentication;
    expected = false;
  };
}
