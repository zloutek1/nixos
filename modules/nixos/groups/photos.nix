# The photos group: Immich and what it runs on, started and stopped together
# with `systemctl start|stop homelab-photos.target`.
{ config, lib, ... }:
let
  cfg = config.homelab.groups.photos;
  units = [
    "immich-server"
    "immich-machine-learning"
    "redis-immich"
    "postgresql"
  ];
in
{
  options.homelab.groups.photos.enable = lib.mkEnableOption "the photos group";

  config = lib.mkIf cfg.enable {
    homelab.services.immich.enable = true;
    homelab.services.caddy.hosts."photos.zloutek1.com" = "127.0.0.1:2283";

    systemd.targets.homelab-photos.wantedBy = [ "multi-user.target" ];
    systemd.slices.homelab-photos = { };
    systemd.services = lib.genAttrs units (_: {
      wantedBy = [ "homelab-photos.target" ];
      partOf = [ "homelab-photos.target" ];
      # The upstream Immich module sets its own Slice.
      serviceConfig.Slice = lib.mkForce "homelab-photos.slice";
    });
  };
}
