{ pkgs, ... }: barName:

{

  programs.waybar.settings.${barName} = {
    "pulseaudio" = {
      # scroll-step = 1; # %; can be a float
      format = "{volume}% {icon}";
      format-bluetooth = "{volume}% {icon}";
      format-bluetooth-muted = "{icon} {format_source}";
      format-muted = "{format_source}";
      format-source = "";
      format-source-muted = "";
      format-icons = {
        headphone = "";
        hands-free = "";
        headset = "";
        phone = "";
        portable = "";
        car = "";
        default = ["" "" ""];
      };
      on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
    };
  };
  
}