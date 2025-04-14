{ config, pkgs, ... }:
let 

  mainMod = config.wayland.windowManager.hyprland.settings.mainMod or "SUPER";

in
{
  wayland.windowManager.hyprland.settings = {
    bind = [
      "${mainMod}, Return, exec, $terminal"
      "${mainMod} SHIFT, Q, killactive,"
      "${mainMod}, L, exec, hyprlock"
      "${mainMod}, E, exec, $fileManager"
      "${mainMod}, Space, togglefloating,"
      "${mainMod}, D, exec, $menu"
      "${mainMod}, P, pseudo, # dwindle"
      "${mainMod}, T, togglesplit, # dwindle"
      "${mainMod}, F, fullscreen, 1"
      "${mainMod}, F2, exec, $browser"
      
      "${mainMod}, I, exec, notify-send \"Active Window Info\" \"$(hyprctl activewindow -j | jq -r '\"Class: \\(.class)\\nInitial Class: \\(.initialClass)\\nTitle: \\(.title)\"'\""
      
      ", PRINT, exec, $HYPRSHOT_DIR hyprshot -m output"
      "${mainMod}, PRINT, exec, $HYPRSHOT_DIR hyprshot -m region"
    ];
  };
}