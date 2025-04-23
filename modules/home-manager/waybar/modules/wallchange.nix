{ ... }: barName: 

{
  
  programs.waybar.settings.${barName} = {
    "custom/wallchange" = {
      format = "󰆊 {}";
      
      exec = "echo; echo 󰆊 switch wallpaper; wallchange next";
      interval = 900; # once 15min

      on-click = "wallchange next";
      on-click-right = "sleep 0.1 && pick-wallpaper";
      
      tooltip = true;
      tooltip-format = "󰆊 switch wallpaper";
    };
  };
  
}