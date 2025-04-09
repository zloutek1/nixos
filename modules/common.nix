{ config, pkgs, inputs, ... }:

{
  imports = [
    ./nix.nix
    ./locale.nix
    ./fonts.nix
  ];

  nixpkgs.config.allowUnfree = true;
  hardware.enableRedistributableFirmware = true;

  environment.systemPackages = with pkgs; [
    # Development
    git
    
    # Utilities
    neovim
    tree
    zip
    unzip
    htop
    jq          # A lightweight and flexible command-line JSON processor
    fastfetch   # neofetch alternative
    zoxide      # better cd
    nsxiv       # image viewer
    stow        # dotfiles manager
    bat         # better cat

    # Networking
    wget
    curl
  ];

  hardware.graphics.enable = true;
}
