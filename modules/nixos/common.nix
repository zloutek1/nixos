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
        # Applications
        nautilus            # file manager

        # Development
        git
        
        # Utilities
        neovim
        tree
        zip
        unzip
        wget
        curl
        htop
        jq                  # A lightweight and flexible command-line JSON processor
        fastfetch           # neofetch alternative
        nsxiv               # image viewer
        stow                # dotfiles manager
        bat                 # better cat
        nixfmt-rfc-style    # Nix formatter
    ];

    hardware.graphics.enable = true;
}
