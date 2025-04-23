{
  config,
  pkgs,
  self,
  lib,
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

  home.username = "tomas";
  home.homeDirectory = lib.getHomeDirectory { inherit pkgs; username = config.home.username; };
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # Applications
    chromium
    obsidian

    # Coding
    vscode
  ];

}
