# Headless home server: Mac mini M1, macOS 27. No home-manager, no Homebrew.
{ username, ... }:
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
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.primaryUser = username;

  networking = {
    hostName = "mac-mini";
    computerName = "mac-mini";
    localHostName = "mac-mini";
  };

  system.stateVersion = 6;

}
