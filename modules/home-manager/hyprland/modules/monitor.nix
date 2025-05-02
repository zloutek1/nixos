{ config, lib, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    monitor = [
      #"HDMI-A-1, 1920x1080, 0x-1200, 1"
      #"eDP-1,    3200x2000, 0x0,     3"
      #"Unknown-1, disable"
      ", highres, auto, 2"
    ];

    xwayland = {
      force_zero_scaling = true;
    };

    # toolkit-specific scale
    env = [
      "GDK_SCALE,2"
      (lib.mkIf config.theme.cursor.enable "XCURSOR_SIZE,${toString config.home.pointerCursor.size}")
    ];
  };
}