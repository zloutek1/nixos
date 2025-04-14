{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings.exec-once = [
    "nm-applet --indicator &"
    "blueman-applet &"
    "waybar &"
    "swww-daemon &"
  ];
}