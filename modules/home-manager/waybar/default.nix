{ pkgs, lib, ... }: 
{

  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        position = "top";
        spacing = 4;

        modules-left = [  ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ "clock" ];

        "hyprland/workspaces" = {
          format = "{icon}";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl disppatch workspace e-1";
          format-icons = {
		        "active" = "";
		        "default" = "";
	        };
          persistent-workspaces = {
            "*" = [ 1 2 3 4 5 6 ];
          };
        };

        "clock" = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%d.%m.%Y %H:%M}";
        };
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