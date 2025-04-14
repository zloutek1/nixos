{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    general = {
      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";
    };
  };
}