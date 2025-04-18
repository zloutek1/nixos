{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let

  matugenConfig = import ./matugen/config.nix { inherit config pkgs; };
  
  update-colors = pkgs.writeShellApplication {
    name = "update-colors";
    runtimeInputs = with pkgs; [
      swww
      matugen
      coreutils
    ];
    text = builtins.readFile ./scripts/update-colors.sh;
  };

  set-wallpaper = pkgs.writeShellApplication {
    name = "set-wallpaper";
    runtimeInputs = with pkgs; [
      swww
      coreutils
      update-colors
    ];
    text = builtins.readFile ./scripts/set-wallpaper.sh;
  };

  get-next-wallpaper = pkgs.writeShellApplication {
    name = "get-next-wallpaper";
    runtimeInputs = with pkgs; [
      swww
      coreutils
      findutils
      set-wallpaper
    ];
    text = builtins.readFile ./scripts/get-next-wallpaper.sh;
  };

  pick-wallpaper = pkgs.writeShellApplication {
    name = "pick-wallpaper";
    runtimeInputs = with pkgs; [
      swww
      nsxiv
      coreutils
      findutils
      set-wallpaper
      update-colors
    ];
    text = builtins.readFile ./scripts/pick-wallpaper.sh;
  };

  next-wallpaper = pkgs.writeShellApplication {
    name = "next-wallpaper";
    runtimeInputs = with pkgs; [
      get-next-wallpaper
      update-colors
      coreutils
    ];
    text = builtins.readFile ./scripts/next-wallpaper.sh;
  };

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
    pkgs.swww
    
    set-wallpaper
    get-next-wallpaper
    update-colors
    pick-wallpaper
    next-wallpaper
  ];
}
