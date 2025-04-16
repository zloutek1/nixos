{ ... }: {

  programs.waybar.settings.mainBar = {

    "custom/power" = {
      "format" = "   ";
      "tooltip" = false;
      "on-click" = "sh $HOME/.config/rofi/bin/powermenu";
    };

  };

}