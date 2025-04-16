{ pkgs, lib, ... }: {

  imports = [
    ./modules/misc.nix
    ./modules/input.nix
    ./modules/nvidia.nix
    ./modules/monitor.nix
    
    ./modules/startup.nix
    
    ./modules/keybinds.nix
    ./modules/laptop.nix
    ./modules/workspaces.nix
    
    ./modules/style.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mainMod" = "SUPER";
      
      "$terminal" = "kitty";
      "$fileManager" = "nautilus";
      "$menu" = "wofi";
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
    swww          # wallpaper app
    hyprcursor    # custor theme
    wl-clipboard  # clipboard

    # Notifications
    dunst
    libnotify
  ];

}