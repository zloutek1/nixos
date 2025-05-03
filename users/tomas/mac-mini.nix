{
  config,
  pkgs,
  self,
  lib,
  username,
  ...
}:
{

  home.username = username;
  home.homeDirectory = lib.getHomeDirectory { inherit pkgs username; };
  home.stateVersion = "24.11";

  programs = {
    zsh.enable = true;
    git.enable = true;
    kitty.enable = true;
  };
  
}
