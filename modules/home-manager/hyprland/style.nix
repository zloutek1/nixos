{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings.general = {
    gaps_in = 5;
    gaps_out = 20;
    border_size = 2;
    resize_on_border = false;
    allow_tearing = false;
    layout = "dwindle";
  };

  wayland.windowManager.hyprland.settings.decoration = {
    rounding = 10;
    active_opacity = 1.0;
    inactive_opacity = 1.0;
    blur = {
      enabled = true;
      size = 3;
      passes = 1;
      vibrancy = 0.1696;
    };
  };

  wayland.windowManager.hyprland.settings.animations = {
    enabled = true;
    bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
    animation = [
      "windows, 1, 7, myBezier"
      "windowsOut, 1, 7, default, popin 80%"
      "border, 1, 10, default"
      "borderangle, 1, 8, default"
      "fade, 1, 7, default"
      "workspaces, 1, 6, default"
    ];
  };
}