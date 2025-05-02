{ config, lib, pkgs, ... }:

{
  options = {
    theme.cursor = {
      enable = lib.mkEnableOption "cursor theme configuration";
    };
  };

  config = lib.mkIf config.theme.cursor.enable {

    home.pointerCursor = {
      name = "Nordzy-cursors";
      package = pkgs.nordzy-cursor-theme;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };

    home.sessionVariables = {
      HYPRCURSOR_THEME = "Nordzy-hyprcursors";
      HYPRCURSOR_SIZE = "${toString config.home.pointerCursor.size}";
    };

  };
}
