{ config, pkgs, ... }:
let 

  mainMod = config.wayland.windowManager.hyprland.settings.mainMod or "SUPER";

in
{
  wayland.windowManager.hyprland.settings = {
    bind = [
      #---------------move focus with mainMod + arrow keys (layout agnostic)------------------------------#
      #---------------------------------------------------------------------------------------------------#
      "${mainMod}, left, movefocus, l"
      "${mainMod}, right, movefocus, r"
      "${mainMod}, up, movefocus, u"
      "${mainMod}, down, movefocus, d"
      
      #---------------move/resize windows with mainMod + arrow keys-------------------------------#
      #-------------------------------------------------------------------------------------------#
      "${mainMod} SHIFT, left, movewindow, l"
      "${mainMod} SHIFT, right, movewindow, r"
      "${mainMod} SHIFT, up, movewindow, u"
      "${mainMod} SHIFT, down, movewindow, d"
      
      #---------------switch workspaces with mainMod + [0-9]----------------------------#
      #---------------------------------------------------------------------------------#
      "${mainMod}, 1, workspace, 1"
      "${mainMod}, 2, workspace, 2"
      "${mainMod}, 3, workspace, 3"
      "${mainMod}, 4, workspace, 4"
      "${mainMod}, 5, workspace, 5"
      "${mainMod}, 6, workspace, 6"
      "${mainMod}, 7, workspace, 7"
      "${mainMod}, 8, workspace, 8"
      "${mainMod}, 9, workspace, 9"
      "${mainMod}, 0, workspace, 10"
      
      #---------------move active window to a workspace with mainMod + SHIFT + [0-9]-------------------#
      #------------------------------------------------------------------------------------------------#
      "${mainMod} SHIFT, 1, movetoworkspacesilent, 1"
      "${mainMod} SHIFT, 2, movetoworkspacesilent, 2"
      "${mainMod} SHIFT, 3, movetoworkspacesilent, 3"
      "${mainMod} SHIFT, 4, movetoworkspacesilent, 4"
      "${mainMod} SHIFT, 5, movetoworkspacesilent, 5"
      "${mainMod} SHIFT, 6, movetoworkspacesilent, 6"
      "${mainMod} SHIFT, 7, movetoworkspacesilent, 7"
      "${mainMod} SHIFT, 8, movetoworkspacesilent, 8"
      "${mainMod} SHIFT, 9, movetoworkspacesilent, 9"
      "${mainMod} SHIFT, 0, movetoworkspacesilent, 10"
      
      "CTRL ${mainMod}, right, movecurrentworkspacetomonitor, r"
      "CTRL ${mainMod}, left, movecurrentworkspacetomonitor, l"
      "CTRL ${mainMod}, up, movecurrentworkspacetomonitor, u"
      "CTRL ${mainMod}, down, movecurrentworkspacetomonitor, d"
      
      #------------------------special workspace (scratchpad)---------------------------#
      #---------------------------------------------------------------------------------#
      "${mainMod}, S, togglespecialworkspace, magic"
      "${mainMod} SHIFT, S, movetoworkspace, special:magic"
      
      #---------------scroll through existing workspaces with mainMod + scroll-------------------#
      #------------------------------------------------------------------------------------------#
      "${mainMod}, mouse_down, workspace, e+1"
      "${mainMod}, mouse_up, workspace, e-1"
    ];

    bindm = [
      #---------------move/resize windows with mainMod + LMB/RMB and dragging-------------------#
      #-------------------------------------------------------------------------------------------#
      "${mainMod}, mouse:272, movewindow"
      "${mainMod}, mouse:273, resizewindow"
    ];
  };
}