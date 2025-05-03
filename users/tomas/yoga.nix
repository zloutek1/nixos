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
    wallchange
    hyprland
    wofi
    rofi
    waybar
    wlogout
    mako
    batsignal
    vscode
    unstable.syncthing
    unstable.keepassxc
    unstable.chromium
  ];

  home.username = username;
  home.homeDirectory = lib.getHomeDirectory { inherit pkgs username; };
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # Applications
    obsidian
    discord
  ];

  xdg.enable = true;
  wayland.windowManager = {
    hyprland.enable = true;
  };
  theme = {
    dark.enable = true;
    cursor.enable = true;
  };
  programs = {
    zsh.enable = true;
    zoxide.enable = true;
    git.enable = true;
    kitty.enable = true;
    nvchad.enable = true;
    wallchange.enable = true;
    rofi.enable = true;
    wlogout.enable = true;
    waybar.enable = true;
    keepassxc.enable = true;
    chromium.enable = true;
  };
  services = {
    mako.enable = true;
    batsignal.enable = true;
    syncthing.enable = true;
  };

}
