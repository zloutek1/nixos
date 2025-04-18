{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings.bind = [
    #---------------volume management-------------------------------------------------#
    #---------------------------------------------------------------------------------#
    ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"
    ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"
    ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

    #---------------backlight management----------------------------------------------#
    #---------------------------------------------------------------------------------#
    ", XF86MonBrightnessUp, exec, brightnessctl set +10%"
    ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
  ];
}