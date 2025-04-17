{ lib, ... }: {

  programs.wofi = {
    enable = true;

    settings = {
      mode = "drun";
      prompt = "Search...";
      
      width = "40%";
      height = "40%";
      # yoffset = 300;
      
      matching = "fuzzy";
      insensitive = true;
      
      term = "kitty";
      hide_scroll = true;
      no_actions = true;
      allow_images = true;
    };

    style = builtins.readFile ./style.css;
  };

  home.activation.writeWaybarTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f $HOME/.config/waybar/colors.css ]; then
      cat "${./colors.css}" > "$HOME/.config/waybar/colors.css"
    fi
  '';

}