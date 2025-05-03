{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.wayland.windowManager.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "compose:ralt";
        kb_rules = "";
        
        follow_mouse = true;
        
        sensitivity = 0;
        
        numlock_by_default = true;
        
        touchpad = {
          natural_scroll = true;
        };
      };

      gestures = {
        workspace_swipe = false;
      };
    };
  };
}