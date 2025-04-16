{ config, pkgs, ... }: {

  config = {
    version_check = true;
  };

  templates = {
    kitty = {
      input_path = "${config.xdg.configHome}/matugen/templates/kitty.conf";
      output_path = "${config.xdg.configHome}/kitty/theme.conf";
      post_hook = "${pkgs.kitty}/bin/kitty @ set-colors --all --configured ${config.xdg.configHome}/kitty/theme.conf";
    };

    hyprland = {
      input_path = "${config.xdg.configHome}/matugen/templates/hyprland.conf";
      output_path = "${config.xdg.configHome}/hypr/theme.conf";
      post_hook = "hyprctl reload";
    };

    nvim = { 
      input_path = "${config.xdg.configHome}/matugen/templates/nvim.lua";
      output_path = "${config.xdg.configHome}/nvim/lua/themes/custom.lua";
    };

    wofi = {
      input_path = "${config.xdg.configHome}/matugen/templates/wofi.css";
      output_path = "${config.xdg.configHome}/wofi/colors.css";
    };
  };

}