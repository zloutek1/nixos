{ pkgs, ... }: {

    home.pointerCursor = {
        name = "Nordzy-cursors";
        package = pkgs.nordzy-cursor-theme;
        size = 24;
        gtk.enable = true;   
        x11.enable = true;   
    };

    home.sessionVariables = {
        HYPRCURSOR_THEME = "Nordzy-hyprcursors";
        HYPRCURSOR_SIZE = "24";
    };

}