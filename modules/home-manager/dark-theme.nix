{ config, pkgs, lib, ... }:

{
  options = {
    theme.dark = {
      enable = lib.mkEnableOption "dark theme configuration";
    };
  };
  config = lib.mkIf config.theme.dark.enable {

    # DConf settings (primarily for GNOME/GTK4 apps)
    # Apply only on Linux systems to avoid errors on Darwin
    dconf.settings = {
      # Standard freedesktop setting for dark preference (GTK4/libadwaita)
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      # Set a specific wallpaper for dark mode via dconf (GNOME)
      "org/gnome/desktop/background" = {
        picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
      };
    };

    # GTK settings (GTK2/GTK3)
    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };

    # Qt settings (Qt5/Qt6)
    qt = {
      enable = true;
      platformTheme.name = "adwaita";
      style = {
        name = "adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };

    # Ensure session variables defined in Home Manager apply correctly
    # Propagates variables set in config.home.sessionVariables (if any)
    systemd.user.sessionVariables = config.home.sessionVariables;

  };
}