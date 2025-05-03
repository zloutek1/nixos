{
  config,
  pkgs,
  self,
  lib,
  username,
  ...
}:
{

  home.packages = with pkgs; [
    obsidian
  ];

  home.stateVersion = "24.11";
  
  programs = {
    zsh.enable = true;
    zoxide.enable = true;
    git.enable = true;
    kitty.enable = true;
    nvchad.enable = true;
  };

}
