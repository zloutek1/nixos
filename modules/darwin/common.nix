{ pkgs, ... }: {

  imports = [
    ./nix.nix
    ./locale.nix
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    neovim
    htop
    jq
    curl
    wget
    tree
    bat
  ];

}
