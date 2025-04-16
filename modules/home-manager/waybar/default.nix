{ pkgs, lib, ... }: 
{

  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        position = "top";
        spacing = 4;

        modules-left = [ "custom/power" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ "tray" "clock" ];

        "custom/power" = import ./modules/power.nix;
        "hyprland/workspaces" = import ./modules/workspaces.nix;
        "clock" = import ./modules/clock.nix;
        "tray" = { "spacing" = 10; };
      };
    };

    style = builtins.readFile ./style.css;

  };

  #home.activation.writeHyprTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #  if [ ! -f $HOME/.config/hypr/theme.conf ]; then
  #    cat "${./theme.conf}" > "$HOME/.config/hypr/theme.conf"
  #  fi
  #'';

  #home.packages = with pkgs; [
  #  waybar
  #];

}