{ config, pkgs, self, ... }: {

  imports = with self.darwinModules; [
  #  ./hardware.nix
  ];

  networking.hostName = "mac-mini";
  system.stateVersion = 5;

}
