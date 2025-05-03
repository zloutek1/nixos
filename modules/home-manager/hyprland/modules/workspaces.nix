{ config, pkgs, lib, ... }:
let 

  switchOrBackScript = pkgs.writeShellScriptBin "switch-or-back" ''
    #!/bin/sh

    # Get the target workspace number from the command line argument
    TARGET_WS="$1"

    # Check if a target was provided
    if [ -z "$TARGET_WS" ]; then
        echo "Error: No target workspace provided."
        exit 1
    fi

   CURRENT_WS=$(${pkgs.hyprland}/bin/hyprctl activeworkspace -j | ${lib.getExe pkgs.jq} '.id')

   if [ "$CURRENT_WS" = "$TARGET_WS" ]; then
        ${pkgs.hyprland}/bin/hyprctl dispatch workspace previous
    else
        ${pkgs.hyprland}/bin/hyprctl dispatch workspace "$TARGET_WS"
    fi
  '';

in
{
  config = lib.mkIf config.wayland.windowManager.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      binds = {
        allow_workspace_cycles = true;
      };

      bind = [
        #---------------move focus with mainMod + arrow keys (layout agnostic)------------------------------#
        #---------------------------------------------------------------------------------------------------#
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        
        #---------------move/resize windows with mainMod + arrow keys-------------------------------#
        #-------------------------------------------------------------------------------------------#
        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"
        
        #---------------switch workspaces with mainMod + [0-9]----------------------------#
        #---------------------------------------------------------------------------------#
        "$mainMod, 1, exec, ${lib.getExe switchOrBackScript} 1"
        "$mainMod, 2, exec, ${lib.getExe switchOrBackScript} 2"
        "$mainMod, 3, exec, ${lib.getExe switchOrBackScript} 3"
        "$mainMod, 4, exec, ${lib.getExe switchOrBackScript} 4"
        "$mainMod, 5, exec, ${lib.getExe switchOrBackScript} 5"
        "$mainMod, 6, exec, ${lib.getExe switchOrBackScript} 6"
        "$mainMod, 7, exec, ${lib.getExe switchOrBackScript} 7"
        "$mainMod, 8, exec, ${lib.getExe switchOrBackScript} 8"
        "$mainMod, 9, exec, ${lib.getExe switchOrBackScript} 9"
        "$mainMod, 0, exec, ${lib.getExe switchOrBackScript} 10"
        
        #---------------move active window to a workspace with mainMod + SHIFT + [0-9]-------------------#
        #------------------------------------------------------------------------------------------------#
        "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
        "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
        "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
        "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
        "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
        "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
        
        "CTRL $mainMod, right, movecurrentworkspacetomonitor, r"
        "CTRL $mainMod, left, movecurrentworkspacetomonitor, l"
        "CTRL $mainMod, up, movecurrentworkspacetomonitor, u"
        "CTRL $mainMod, down, movecurrentworkspacetomonitor, d"
        
        #------------------------special workspace (scratchpad)---------------------------#
        #---------------------------------------------------------------------------------#
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        
        #---------------scroll through existing workspaces with mainMod + scroll-------------------#
        #------------------------------------------------------------------------------------------#
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];

      bindm = [
        #---------------move/resize windows with mainMod + LMB/RMB and dragging-------------------#
        #-------------------------------------------------------------------------------------------#
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };
}