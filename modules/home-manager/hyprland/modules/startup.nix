{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings.exec-once = [
    #-----------clipboard manager------------#
    #----------------------------------------#
    "wl-paste --type text --watch cliphist store" # Stores only text data
    "wl-paste --type image --watch cliphist store" # Stores only image data
    
    #-------------bar, wallpaper & notification daemon--------------#
    #---------------------------------------------------------------#
    "swww-daemon"
    "waybar"
    "swaync"

    #--------------applets---------------#
    #------------------------------------#
    "nm-applet --indicator"
    "blueman-applet"
  ];
}