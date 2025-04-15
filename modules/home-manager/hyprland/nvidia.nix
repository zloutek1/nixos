{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    env = [
      "XDG_SESSION_TYPE,wayland"
      "GBM_BACKEND,nvidia-drm"
    ];

    cursor = {
      no_hardware_cursors = true;
    };
  };
}