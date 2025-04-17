{
  format = "{icon}";
  on-scroll-up = "hyprctl dispatch workspace e+1";
  on-scroll-down = "hyprctl disppatch workspace e-1";
  format-icons = {
    "active" = "";
    "default" = "";
  };
  persistent-workspaces = {
    "*" = [ 1 2 3 4 5 ];
  };
}