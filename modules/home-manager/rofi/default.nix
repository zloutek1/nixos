{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.programs.rofi.enable {
    programs.rofi = {
      # enable = true;
      package = pkgs.rofi-wayland;
      plugins = with pkgs; [ rofi-calc rofi-emoji ];
      terminal = "${pkgs.kitty}/bin/kitty";
    };

    xdg.configFile."rofi/config.rasi".text = builtins.readFile ./config.rasi;
    xdg.configFile."rofi/wallpaper-select.rasi".text = builtins.readFile ./wallpaper-select.rasi;
    home.activation.writeRofiTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -f $HOME/.config/rofi/colors.rasi ]; then
        cat "${./colors.rasi}" > "$HOME/.config/rofi/colors.rasi"
      fi
    '';

    # for rofi-emoji to insert emojis directly
    home.packages = [ pkgs.xdotool ];
  };
}