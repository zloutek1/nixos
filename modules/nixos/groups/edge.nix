# The edge group: what puts services on the tailnet.
{ config, lib, ... }:
let
  cfg = config.homelab.groups.edge;
  units = [
    "tailscaled"
    "caddy"
  ];
in
{
  options.homelab.groups.edge.enable = lib.mkEnableOption "the edge group";

  config = lib.mkIf cfg.enable {
    homelab.services.tailscale.enable = true;
    homelab.services.caddy.enable = true;

    systemd.targets.homelab-edge.wantedBy = [ "multi-user.target" ];
    systemd.slices.homelab-edge = { };
    systemd.services = lib.genAttrs units (_: {
      wantedBy = [ "homelab-edge.target" ];
      partOf = [ "homelab-edge.target" ];
      serviceConfig.Slice = lib.mkForce "homelab-edge.slice";
    });
  };
}
