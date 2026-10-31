# Headless home server: Mac mini M1, macOS 27. No home-manager, no Homebrew.
{

  imports = [
    ../../overlays
    ../../modules/darwin/common.nix
    ../../users/tomas/darwin.nix
    ./power.nix
    ./ssh.nix
    ./firewall.nix
    ./shell.nix
    ./updates.nix
    ./t7.nix
    ./wifi.nix
    ./desktop-off.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.primaryUser = "tomas";

  networking = {
    hostName = "mac-mini";
    computerName = "mac-mini";
    localHostName = "mac-mini";
  };

  system.stateVersion = 6;

}
