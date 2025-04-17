{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    general = {
      border_size = 2;
      gaps_in = 5;
      gaps_out = 10;

      "col.active_border" = "$primary $primary_container 45deg";
      "col.inactive_border" = "$on_surface";
    };

    decoration = {
      rounding = 10;
      
      active_opacity = 1.0;
      inactive_opacity = 1.0;
      fullscreen_opacity = 1.0;

      blur = {
        enabled = true;
        size = 2;
        passes = 3;
        ignore_opacity = true;
        new_optimizations = true;
        special = true;
        popups = true;
      };
    };

    animations = {
      enabled = true;
      
      bezier = [
        "wind, 0.05, 0.9, 0.1, 1.05"
        "winIn, 0.1, 1.1, 0.1, 1.1"
        "winOut, 0.3, -0.3, 0, 1"
        "liner, 1, 1, 1, 1"
        "overshot, 0.05, 0.9, 0.1, 1.05"
        "smoothOut, 0.5, 0, 0.99, 0.99"
        "smoothIn, 0.5, -0.5, 0.68, 1.5"
      ];
      
      animation = [
        "windows, 1, 7, wind"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 7, default"
        "workspaces, 1, 6, default"
      ];
    };
  };
}