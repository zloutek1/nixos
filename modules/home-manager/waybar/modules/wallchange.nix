{ ... }: barName: 

{
  
  programs.waybar.settings.${barName} = {
    "custom/wallchange" = {
      format = "󰆊{}";
      exec = "echo ; echo 󰆊 switch wallpaper";
      on-click = "wallchange next";
      on-click-right = "sleep 0.1 && pick-wallpaper";
      #on-click-right = "next-wallpaper --previous";
      interval = 900; # once 15min
      tooltip = true;
    };
  };
  
}