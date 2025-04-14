{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let

  rotate-wallpaper = import ./rotate-wallpaper.nix { inherit pkgs; };
  matugenConfig = import ./config.nix { inherit config pkgs; };

in
{
  xdg.configFile."matugen/templates" = {
    source = ./templates;
    recursive = true;
  };

  xdg.configFile."matugen/config.toml" = {
    text = inputs.nix-std.lib.serde.toTOML matugenConfig;
  };

  home.packages = [
    pkgs.matugen
    rotate-wallpaper
  ];
}
