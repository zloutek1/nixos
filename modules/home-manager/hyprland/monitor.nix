{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "HDMI-A-1, 1920x1080, 0x-1200, 1"
      "eDP-1,    1920x1200, 0x0,    1"
      "Unknown-1, disable"
    ];
  };
}