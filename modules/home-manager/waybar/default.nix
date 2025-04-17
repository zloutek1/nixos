{ pkgs, lib, ... }: 
let

  available-modules = import ./modules { inherit pkgs; };

  modules-left = [ "custom/power" "clock" "tray" ];
  modules-center = [ "hyprland/workspaces" ];
  modules-right = [ "pulseaudio" "network" "bluetooth" "battery" ];

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

  #home.activation.writeHyprTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #  if [ ! -f $HOME/.config/hypr/theme.conf ]; then
  #    cat "${./theme.conf}" > "$HOME/.config/hypr/theme.conf"
  #  fi
  #'';

}