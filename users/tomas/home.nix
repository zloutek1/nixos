{
  config,
  pkgs,
  self,
  lib,
  username,
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
    #wofi
    rofi
    waybar
    wlogout
    mako
    batsignal
  ];

  home.username = username;
  home.homeDirectory = lib.getHomeDirectory { inherit pkgs username; };
  home.stateVersion = "24.11";

  preferences = {
    shells = [ "zsh" "bash" ];
  };

  home.packages = with pkgs; [
    # Applications
    chromium
    obsidian

    # Coding
    vscode
  ];

}
