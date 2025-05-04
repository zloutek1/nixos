{ config, pkgs, self, ... }: {

  imports = with self.darwinModules; [
  #  ./hardware.nix
    clock
    dock
    finder
    keyboard
    settings-reload
    setup-tools
    app-links
  ];

  networking.hostName = "mac-mini";
  system.stateVersion = 5;

}
