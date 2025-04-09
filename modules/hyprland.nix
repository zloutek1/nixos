{ config, pkgs, ... }: {

    programs.hyprland = {
        enable = true;
        xwayland.enable = true; # Essential for running X11 apps
    };

    # Required for portals (screen sharing, file pickers, etc.) under Wayland
    xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
            xdg-desktop-portal-hyprland
            xdg-desktop-portal-gtk # Fallback for some apps
        ];
        # Ensure the Hyprland portal is the default
        config.hyprland = {
            default = [ "hyprland" "gtk" ];
        };
    };

    environment.systemPackages = with pkgs; [
        waybar      # navbar
        swww        # wallpaper app
        kitty       # terminal
        wofi        # app launcher
        dunst       # notifications
        libnotify   # ^
    ];

    environment.sessionVariables = {
        # Force Firefox to use Wayland
        MOZ_ENABLE_WAYLAND = "1";
        # Force Qt apps to use Wayland
        QT_QPA_PLATFORM = "wayland";
        # Variables below are often set automatically but can be explicit
        # XDG_SESSION_TYPE = "wayland";
        # XDG_CURRENT_DESKTOP = "Hyprland";
    };


}
