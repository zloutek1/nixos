{ pkgs, ... }:
barName:

{

  programs.waybar.settings.${barName} = {
    "custom/power" = {
      "format" = "";
      "tooltip" = false;
      "on-click" = "${pkgs.wlogout}/bin/wlogout --protocol layer-shell";
    };
  };

}
