{ config, pkgs, lib, ... }:
let 

  hypr-volume-control = pkgs.writeShellApplication {
    name = "hypr-volume-control";
    runtimeInputs = [ pkgs.wireplumber ];
    text = builtins.readFile ../scripts/hypr-volume-control.sh;
  };

  hypr-brightness-control = pkgs.writeShellApplication {
    name = "hypr-brightness-control";
    runtimeInputs = [ pkgs.brightnessctl ];
    text = builtins.readFile ../scripts/hypr-brightness-control.sh;
  };
  
in
{
  config = lib.mkIf config.wayland.windowManager.hyprland.enable {
    home.packages = [
      hypr-volume-control
      hypr-brightness-control
    ];

    wayland.windowManager.hyprland.settings = {
      bind = [
        #---------------volume management-------------------------------------------------#
        #---------------------------------------------------------------------------------#
        ", XF86AudioMute, exec, ${lib.getExe hypr-volume-control} toggle"
      ];
      binde = [ # e = repeat, will repeat when held.
        #---------------volume management-------------------------------------------------#
        #---------------------------------------------------------------------------------#
        ", XF86AudioRaiseVolume, exec, ${lib.getExe hypr-volume-control} up"
        ", XF86AudioLowerVolume, exec, ${lib.getExe hypr-volume-control} down"
        
        #---------------backlight management----------------------------------------------#
        #---------------------------------------------------------------------------------#
        ", XF86MonBrightnessUp, exec, ${lib.getExe hypr-brightness-control} up"
        ", XF86MonBrightnessDown, exec, ${lib.getExe hypr-brightness-control} down"
      ];
    };
  };
}