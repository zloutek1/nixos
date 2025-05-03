{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.wayland.windowManager.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        # --[ clipboard
        "wl-paste --type text --watch cliphist store" # Stores only text data
        "wl-paste --type image --watch cliphist store" # Stores only image data
        
        # --[ wallpaper
        "swww-daemon"

        # --[ bar
        "waybar"

        # --[ Hyprshade
        "dbus-update-activation-environment --systemd HYPRLAND_INSTANCE_SIGNATURE"
      ];
      exec = [
        # --[ Hyprshade
        "${pkgs.hyprshade}/bin/hyprshade auto"
      ];
    };
  };
}