{ config, pkgs, ... }: {

  config = {
    version_check = true;
  };

  templates = {
    kitty = {
      input_path = "${config.xdg.configHome}/matugen/templates/kitty.conf";
      output_path = "${config.xdg.configHome}/kitty/theme.conf";
      post_hook = ''
        for sock in $(ls /tmp/kitty.sock-*); do 
          ${pkgs.kitty}/bin/kitty @ --to "unix:$sock" set-colors ${config.xdg.configHome}/kitty/theme.conf; 
        done
      '';
    };

    hyprland = {
      input_path = "${config.xdg.configHome}/matugen/templates/hyprland.conf";
      output_path = "${config.xdg.configHome}/hypr/theme.conf";
      post_hook = "hyprctl reload --quiet";
    };

    nvim = { 
      input_path = "${config.xdg.configHome}/matugen/templates/nvim.lua";
      output_path = "${config.xdg.configHome}/nvim/lua/themes/custom.lua";
    };

    wofi = {
      input_path = "${config.xdg.configHome}/matugen/templates/wofi.css";
      output_path = "${config.xdg.configHome}/wofi/colors.css";
    };

    waybar = {
      input_path = "${config.xdg.configHome}/matugen/templates/waybar.css";
      output_path = "${config.xdg.configHome}/waybar/colors.css";
    };

    rofi = {
      input_path = "${config.xdg.configHome}/matugen/templates/rofi.rasi";
      output_path = "${config.xdg.configHome}/rofi/colors.rasi";
    };

    mako = {
      input_path = "${config.xdg.configHome}/matugen/templates/mako";
      output_path = "${config.xdg.configHome}/mako/colors";
    };
  };

}