{
  format = "󰆊{}";
  exec = "echo ; echo 󰆊 switch wallpaper";
  on-click = "next-wallpaper";
  on-click-middle = "sleep 0.1 && pick-wallpaper";
  on-click-right = "next-wallpaper --previous";
  interval = 86400; # once every day
  tooltip = true;
}