{ config, pkgs, lib, hostname, ... }: 
let

  modules = import ./modules { inherit pkgs; };
  mkWaybarModule = import ./mkWaybarModule.nix { inherit lib; };

  waybarConfig = {
    programs.waybar = {
      # enable = true;

      settings = {
        mainBar = {
          position = "top";
          spacing = 4;
          reload_style_on_change = true;

          modules-left = [ "custom/power" "clock" "custom/wallchange" "tray" ];
          modules-center = [ "hyprland/workspaces" ];
          modules-right = [ "pulseaudio" "backlight" "network" "bluetooth" "battery" ];
        };
      };

      style = builtins.readFile ./style.css;

    };

    home.activation.writeWaybarTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -f $HOME/.config/waybar/colors.css ]; then
        cat "${./colors.css}" > "$HOME/.config/waybar/colors.css"
      fi
    '';
  };

in
{ 
  config = lib.mkIf config.programs.waybar.enable (lib.mkMerge (
    [waybarConfig] ++ 
    (mkWaybarModule waybarConfig modules)
  ));
}