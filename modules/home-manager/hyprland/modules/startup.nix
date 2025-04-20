{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings.exec-once = [
    # --[ clipboard
    "wl-paste --type text --watch cliphist store" # Stores only text data
    "wl-paste --type image --watch cliphist store" # Stores only image data
    
    # --[ wallpaper
    "swww-daemon"

    # --[ bar
    "waybar"

    # --[ Hyprshade
    "${pkgs.hyprshade}/bin/hyprshade auto"
    "dbus-update-activation-environment --systemd HYPRLAND_INSTANCE_SIGNATURE"
  ];
}