{ pkgs, ... }: {

  imports = [
    ./nix.nix
    ./locale.nix
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    gh
    neovim
    htop
    jq
    curl
    wget
    tree
    bat
  ];

}
