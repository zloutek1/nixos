# Caddy, in front of every web service, reachable only over the tailnet: the
# firewall opens 443 on tailscale0 alone, and Lima forwards nothing to the Mac.
# Certificates come from Let's Encrypt by DNS-01, so nothing has to reach it
# from the internet. The Cloudflare token should only be allowed to edit DNS.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homelab.services.caddy;
in
{
  options.homelab.services.caddy = {
    enable = lib.mkEnableOption "Caddy";
    hosts = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        "photos.example.com" = "127.0.0.1:2283";
      };
      description = "Tailnet-only HTTPS names and the local address each proxies to.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
        hash = "sha256-xRJ5evsAJ2akg47j3Bt6YDXJOgX88B/rKNP50KSVyNY=";
      };
      # The guest resolves through MagicDNS, which can't find the zone's SOA
      # for the challenge record, so the DNS-01 solver asks Cloudflare directly.
      virtualHosts = lib.mapAttrs (_: upstream: {
        extraConfig = ''
          tls {
            dns cloudflare {env.CLOUDFLARE_API_TOKEN}
            resolvers 1.1.1.1 1.0.0.1
          }
          reverse_proxy ${upstream}
        '';
      }) cfg.hosts;
    };
    sops.secrets.cloudflare-api-token = { };
    sops.templates."caddy.env".content = ''
      CLOUDFLARE_API_TOKEN=${config.sops.placeholder.cloudflare-api-token}
    '';
    systemd.services.caddy.serviceConfig.EnvironmentFile = config.sops.templates."caddy.env".path;

    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 443 ];

    # Through Caddy on the tailnet address, as a phone would reach it.
    homelab.checks = lib.mapAttrs' (
      name: _:
      lib.nameValuePair name ''
        ip=$(${pkgs.tailscale}/bin/tailscale ip -4)
        ${pkgs.curl}/bin/curl -fsS -o /dev/null --resolve "${name}:443:$ip" https://${name}/
        end=$(echo | ${pkgs.openssl}/bin/openssl s_client -connect "$ip:443" -servername ${name} 2>/dev/null |
          ${pkgs.openssl}/bin/openssl x509 -noout -enddate | cut -d= -f2)
        days=$(( ($(date -d "$end" +%s) - $(date +%s)) / 86400 ))
        echo "certificate: $days days left"
        [ "$days" -ge 14 ]
      ''
    ) cfg.hosts;
  };
}
