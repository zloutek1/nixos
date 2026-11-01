# The guest is the tailnet's one node, `homelab`, tagged tag:server so its key
# never expires. It joins once with a one-time, pre-authorized, tagged auth key;
# after that its identity is the state in /var/lib/tailscale, which is backed
# up, so a rebuilt guest rejoins as the same node without a new key.
# What may reach it is the tailnet policy (tailscale/policy.hujson).
{ config, lib, ... }:
let
  cfg = config.homelab.services.tailscale;
in
{
  options.homelab.services.tailscale.enable = lib.mkEnableOption "Tailscale";

  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      authKeyFile = config.sops.secrets.tailscale-auth-key.path;
      extraUpFlags = [
        "--advertise-tags=tag:server"
        "--ssh=false"
      ];
      openFirewall = true;
    };
    sops.secrets.tailscale-auth-key = { };

    services.restic.backups.homelab.paths = lib.mkIf config.homelab.services.backup.enable [
      "/var/lib/tailscale/tailscaled.state"
    ];

    homelab.checks.tailscale = "${config.services.tailscale.package}/bin/tailscale status --peers=false";
  };
}
