{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings.exec-once = [
    #-----------clipboard manager------------#
    #----------------------------------------#
    "wl-paste --type text --watch cliphist store" # Stores only text data
    "wl-paste --type image --watch cliphist store" # Stores only image data
    
    #-------------bar, wallpaper & notification daemon--------------#
    #---------------------------------------------------------------#
    "killall -q swww;sleep .5 && swww-daemon"
    "killall -q waybar;sleep .5 && waybar"
    "killall -q swaync;sleep .5 && swaync"

    #--------------applets---------------#
    #------------------------------------#
    "nm-applet --indicator"
    "blueman-applet"
  ];
}