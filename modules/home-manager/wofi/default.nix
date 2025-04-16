{ lib, ... }: {

  programs.wofi = {
    enable = true;

    settings = {
      mode = "run";
      prompt = "Search...";
      
      width = "40%";
      height = "40%";
      location = 2;
      yoffset = 300;
      
      hide_scroll = true;
      insensitive = true;
      matching = "fuzzy";
      term = "kitty";
      line_wrap = "word";
      signle_click = true;
      allow_images = true;
    };

    style = builtins.readFile ./style.css;
  };

  #home.activation.writeWofiTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #  if [ ! -f $HOME/.config/wofi/colors.css ]; then
  #    cat "${./colors.css}" > "$HOME/.config/wofi/colors.css"
  #  fi
  #'';

}