{ pkgs, lib, ... }: {

  imports = [
    ./misc.nix
    ./input.nix
    ./nvidia.nix
    ./monitor.nix
    
    ./startup.nix
    
    ./keybinds.nix
    ./laptop.nix
    ./workspaces.nix
    
    ./style.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mainMod" = "SUPER";
      
      "$terminal" = "kitty";
      "$fileManager" = "dolphin";
      "$menu" = "wofi --conf \"$HOME/.config/hypr/wofi/config\" --style \"$HOME/.config/hypr/wofi/style.css\" -show drun";
      "$browser" = "chromium";
      
      "$lock" = "hyprlock";
      
      "$screenshot" = "$HYPRSHOT_DIR hyprshot -m output";
      "$screenshotRegion" = "$HYPRSHOT_DIR hyprshot -m region";
      
      source = "./theme.conf";
    };
  };

  home.activation.writeHyprTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f $HOME/.config/hypr/theme.conf ]; then
      cat "${./theme.conf}" > "$HOME/.config/hypr/theme.conf"
    fi
  '';
  
  home.packages = with pkgs; [
    waybar        # navbar
    swww          # wallpaper app
    kitty         # terminal
    wofi          # app launcher
    hyprcursor    # custor theme
    wl-clipboard  # clipboard

    # Notifications
    dunst
    libnotify
  ];

}