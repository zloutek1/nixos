{ ... }: barName: 

{

  programs.waybar.settings.${barName} = {
    "clock" = {
      format = "{:%H:%M}";
      format-alt = "{:%d.%m.%Y %H:%M}";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    };
  };

}