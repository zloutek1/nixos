{
  pkgs,
  self,
  lib,
  username,
  inputs,
  ...
}:
{

  imports = with self.homeModules; [
    common
    cursor
    dark-theme
    xdg
    zsh
    zoxide
    git
    kitty
    nvim
    wallpaper
    hyprland
    wofi
    waybar
    wlogout
    mako
    wlsunset
  ];

  home.username = username;
  home.homeDirectory = lib.getHomeDirectory { inherit pkgs username; };
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # Applications
    chromium
    obsidian

    # Coding
    vscode
  ];

}
