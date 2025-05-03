{ ... }: {

  imports = [
    ./nix.nix
    ./locale.nix
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Applications
    
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
    bat                 # better cat
    nixfmt-rfc-style    # Nix formatter
  ];

}