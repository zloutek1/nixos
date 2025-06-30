{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.wayland.windowManager.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        "opacity 0.90 0.90,class:^(firefox)$"
        "opacity 0.80 0.80,class:^(Steam)$"
        "opacity 0.80 0.80,class:^(steam)$"

        "opacity 0.80 0.80,class:^(discord)$" #Discord-Electron

        "opacity 0.80 0.70,class:^(pavucontrol)$"
        "opacity 0.80 0.70,class:^(blueman-manager)$"
        "opacity 0.80 0.70,class:^(nm-applet)$"
        "opacity 0.80 0.70,class:^(nm-connection-editor)$"

        "float,class:^(pavucontrol)$"
        "float,class:^(blueman-manager)$"
        "float,class:^(nm-applet)$"
        "float,class:^(nm-connection-editor)$"

        "tile,initialTitle:^(Godot)$,initialClass:^(Godot)$"
        "float,title:^((.*)(DEBUG)),initialClass:^(Godot)$,initialTitle:^(.*)(DEBUG)(.*)$,class:^(Godot)$"
      ];
    };
  };
}