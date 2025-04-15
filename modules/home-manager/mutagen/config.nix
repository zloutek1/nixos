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
  };

}