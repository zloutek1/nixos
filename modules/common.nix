{ config, pkgs, inputs, ... }:

{
  imports = [
    ./locale.nix
    ./fonts.nix
    ./users.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    brave
    neovim
    git
    zoxide
    vscode
    sddm-astronaut
  ];

  hardware.graphics.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  system.stateVersion = "24.11";
}
