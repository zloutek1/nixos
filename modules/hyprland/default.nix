{ config, pkgs, ... }: {

    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
    };

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    environment.systemPackages = with pkgs; [
     waybar
     
     dunst
     libnotify
     
     swww
     
     kitty
     
     rofi-wayland
  ];


}