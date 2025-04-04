{ config, pkgs, inputs, ... }:

{
  imports = [
    ./locale.nix
    ./fonts.nix
    ./users.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;
  hardware.enableRedistributableFirmware = true;

  environment.systemPackages = with pkgs; [
    # Applications
    brave
    obsidian

    # Development
    git
    vscode

    # Utilities
    neovim
    tree
    zip
    unzip
    fastfetch   # neofetch alternative
    zoxide      # better cd
    nsxiv       # image viewer
    stow        # dotfiles manager

    # Networking
    wget
    curl
  ];

  hardware.graphics.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  system.stateVersion = "24.11";

  nix = {
    settings.auto-optimise-store = true;
    gc = { 
      automatic = true; 
      persistent = true; 
      dates = "daily"; 
      options = "--delete-older-than 1d"; 
    };
  };
}
