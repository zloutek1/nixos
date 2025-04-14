{ pkgs, ... }: {

  imports = [
    ./input.nix
    ./keybinds.nix
    ./workspaces.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "dolphin";
      "$menu" = "wofi --conf \"$HOME/.config/hypr/wofi/config\" --style \"$HOME/.config/hypr/wofi/style.css\" -show drun";
      "$browser" = "chromium";
      
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      
      master = {
        new_status = "master";
      };
      
      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = false;
      };
    };
  };

  home.packages = with pkgs; [
    waybar # navbar
    swww # wallpaper app
    kitty # terminal
    wofi # app launcher
    hyprcursor # custor theme

    # Notifications
    dunst
    libnotify
  ];

}