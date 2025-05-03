{ ... }: barName: 
{

  programs.waybar.settings.${barName} = {
    "tray" = { 
      icon-size = 14; 
      spacing = 10;
    };
  };
   
}