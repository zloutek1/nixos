{ ... }: barName: 

{

  programs.waybar.settings.${barName} = {
    "backlight" = {
      #device = "acpi_video1";
      format = "{icon} {percent}%";
      format-icons = [ "" "" "" "" "" "" "" "" "" ];
    };
  };

}