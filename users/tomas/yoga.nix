{
  config,
  pkgs,
  lib,
  ...
}:
let
  identity = import ./identity.nix;
in
{

  home.username = "tomas";
  home.homeDirectory = "/home/tomas";
  home.stateVersion = "24.11";

  # Defaults that changed in home-manager 26.05, kept at their old values
  # until yoga is in use again and the new ones can be tried on it.
  xdg.userDirs.setSessionVariables = true;
  gtk.gtk4.theme = config.gtk.theme;
  wayland.windowManager.hyprland.configType = "hyprlang";

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
    git = {
      enable = true;
      settings.user = { inherit (identity) name email; };
    };
    kitty.enable = true;
    nvchad.enable = true;
    wallchange.enable = true;
    rofi.enable = true;
    wlogout.enable = true;
    waybar.enable = true;
    keepassxc.enable = true;
    chromium.enable = true;

    development = {
      java.enable = true;
      web.enable = true;
      godot.enable = true;
      python.enable = true;
    };
  };
  services = {
    mako.enable = true;
    batsignal.enable = true;
    syncthing.enable = true;
  };

}
