{ pkgs, lib, ... }: 
{

  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        position = "top";
        spacing = 4;

        modules-left = [ "custom/power" "clock" "tray" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ "bluetooth" "pulseaudio" "network" "battery" ];

        "custom/power" = import ./modules/power.nix { inherit pkgs; };
        "clock" = import ./modules/clock.nix;
        "tray" = { "icon-size" = 14; "spacing" = 10; };

        "hyprland/workspaces" = import ./modules/workspaces.nix;

        "bluetooth" = import ./modules/bluetooth.nix { inherit pkgs; };
        "network" = import ./modules/wifi.nix { inherit pkgs; };
        "pulseaudio" = import ./modules/pulseaudio.nix { inherit pkgs; };
        "battery" = import ./modules/battery.nix;
      };
    };

    style = builtins.readFile ./style.css;

  };

  #home.activation.writeHyprTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #  if [ ! -f $HOME/.config/hypr/theme.conf ]; then
  #    cat "${./theme.conf}" > "$HOME/.config/hypr/theme.conf"
  #  fi
  #'';

}