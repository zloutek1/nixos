{ pkgs, ... }:
barName:

{

  programs.waybar.settings.${barName} = {
    "network" = {
      format-wifi = "";
      format-ethernet = "";
      format-disconnected = "";
      tooltip-format-disconnected = "Error";
      tooltip-format-wifi = "{essid} ({signalStrength}%) ";
      tooltip-format-ethernet = "{ifname} 🖧 ";
      on-click = "${pkgs.kitty}/bin/kitty nmtui";
    };
  };

}
