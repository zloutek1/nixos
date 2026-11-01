# The NixOS guest that runs every service, under Lima VZ on the Mac mini
# (the VM itself is hosts/mac-mini/homelab). Services and groups are modules in
# modules/nixos/{services,groups}; this file picks which groups run.
#
# Deploy from the Mac: `rebuild-homelab` (it builds here, on the guest).
{
  imports = [
    ./lima.nix
    ./secrets.nix
    ../../overlays
    ../../modules/common/nix.nix
    ../../modules/nixos/homelab.nix
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  networking.hostName = "homelab";
  time.timeZone = "Europe/Bratislava";

  homelab.groups.edge.enable = true;
  homelab.groups.photos.enable = true;
  homelab.services.backup.enable = true;

  nix.gc.dates = "weekly";
  boot.loader.grub.configurationLimit = 10;
  services.journald.extraConfig = "SystemMaxUse=2G";

  # Reached only as the second hop: `ssh mac-mini`, then `ssh homelab`.
  # Reaching it already takes a shell on the Mac, so sudo asks for nothing.
  users.users.tomas = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEUv7f7yhTCVOQjFxXYk3GfWopaCfaAy9V6+/ULOIwQA tomas@mac-mini"
    ];
  };
  security.sudo.wheelNeedsPassword = false;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # SSH comes in through Lima's forward; everything else over the tailnet.
  networking.firewall.enable = true;

  system.stateVersion = "26.05";
}
