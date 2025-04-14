{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let

  next-wallpaper = pkgs.writeShellApplication {
    name = "next-wallpaper";
    runtimeInputs = with pkgs; [
      swww
      coreutils
      findutils
    ];
    text = builtins.readFile ./next-wallpaper.sh;
  };

  update-colors = pkgs.writeShellApplication {
    name = "update-colors";
    runtimeInputs = with pkgs; [
      swww
      matugen
    ];
    text = builtins.readFile ./update-colors.sh;
  };

  rotate-wallpaper = pkgs.writeShellApplication {
    name = "rotate-wallpaper";
    runtimeInputs = [ next-wallpaper update-colors ];
    text = ''
      #!/usr/bin/env bash
      ${next-wallpaper}/bin/next-wallpaper
      ${update-colors}/bin/update-colors
    '';
  };

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
    next-wallpaper
    update-colors
    rotate-wallpaper
  ];
}
