{ pkgs, lib, hostname, ... }: 
let

  available-modules = import ./modules { inherit pkgs lib hostname; };

  modules-left = [ "custom/power" "custom/nix-updates" "clock" "tray" ];
  modules-center = [ "hyprland/workspaces" ];
  modules-right = [ "pulseaudio" "backlight" "network" "bluetooth" "battery" ];

  allModuleNames = modules-left ++ modules-center ++ modules-right;
  modules = lib.genAttrs allModuleNames (name: available-modules.${name});

in
{

  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        position = "top";
        spacing = 4;
        reload_style_on_change = true;

        inherit modules-left modules-center modules-right;
      } 
      // modules;
    };

    style = builtins.readFile ./style.css;

  };

  home.activation.writeWaybarTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f $HOME/.config/waybar/colors.css ]; then
      cat "${./colors.css}" > "$HOME/.config/waybar/colors.css"
    fi
  '';

}