{ config, pkgs, lib, ... }: let

  rotate-wallpaper = pkgs.writeShellApplication {
    name = "rotate-wallpaper";
    runtimeInputs = with pkgs; [ swww coreutils findutils ];
    text = builtins.readFile ./rotate-wallpaper.sh;
  };

  switch-theme = pkgs.writeShellApplication {
    name = "switch-theme";
    runtimeInputs = with pkgs; [ swww matugen ];
    text = builtins.readFile ./switch-theme.sh;
  };

in {
  home.file.".config/matugen/config.toml" = { source = ./config.toml; };
  home.file.".config/matugen/templates/kitty.conf" = { source = ./templates/kitty.conf; };

  home.packages = [
    pkgs.matugen
    rotate-wallpaper
    switch-theme
  ];
}