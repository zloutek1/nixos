{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let

  rotate-wallpaper = import ./scripts/rotate-wallpaper.nix { inherit pkgs; };
  matugenConfig = import ./matugen/config.nix { inherit config pkgs; };

in
{
  xdg.configFile."matugen/templates" = {
    source = ./matugen/templates;
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
