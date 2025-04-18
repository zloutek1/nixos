{
  format = "󰆊{}";
  exec = "echo ; echo 󰆊 switch wallpaper";
  on-click = "next-wallpaper";
  #on-click-right = "previous-wallpaper";
  on-click-right = "sleep 0.1 && pick-wallpaper";
  interval = 86400; # once every day
  tooltip = true;
}