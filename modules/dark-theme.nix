{ config, pkgs, ... }: {

    dconf.settings = {
        "org/gnome/desktop/background" = {
            picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
        };
        "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
        };
    };

    gtk = {
        enable = true;
        theme = {
            name = "Adwaita-dark";
            package = pkgs.gnome.gnome-themes-extra;
        };
    };

    # Wayland, X, etc. support for session vars
    systemd.user.sessionVariables = config.home-manager.users.justinas.home.sessionVariables;

    qt = {
        enable = true;
        platformTheme = "gnome";
        style = "adwaita-dark";
    };

}
