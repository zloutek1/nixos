{ pkgs, lib, ... }: 
let
  modules = import ./modules { inherit pkgs; };
in
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

        inherit (modules) "custom/power" "clock" "tray" "hyprland/workspaces" "bluetooth" "network" "pulseaudio" "battery";
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