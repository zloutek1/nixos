{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.wayland.windowManager.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      bind = [
        #---------------application & run launcher----------------------------------------#
        #---------------------------------------------------------------------------------#
        "$mainMod, Return, exec, $terminal"
        "$mainMod, F2, exec, $browser"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, D, exec, $menu"
        "$mainMod, L, exec, $lock"
        
        #---------------taking screenshot-------------------------------------------------#
        #---------------------------------------------------------------------------------#
        ", PRINT, exec, $screenshot"
        "$mainMod, PRINT, exec, $screenshotRegion"

        #--------------------window management-------------------------------------------#
        #--------------------------------------------------------------------------------#
        "$mainMod SHIFT, Q, killactive,"
        "$mainMod, F, fullscreen, 1"
        
        #------------------layout management--------------------------------------------#
        #-------------------------------------------------------------------------------#
        
        # floating layout
        "$mainMod, Space, togglefloating,"
        
        # switch between master and dwindle layout
        "$mainMod, TAB, exec, hyprctl keyword general:layout \"dwindle\""      # switch to dwindle layout
        "$mainMod SHIFT, TAB, exec, hyprctl keyword general:layout \"master\"" # switch to master layout

        # Dwindle Layout
        "$mainMod SHIFT, T, togglesplit" # only works on dwindle layout
        "$mainMod, P, pseudo," # dwindle

        #--------------------exit hyprland-----------------------------------------------#
        #--------------------------------------------------------------------------------#
        "CTRL ALT, Delete, exec, hyprctl dispatch exit 0"
      ];
    };
  };
}