{ pkgs, ... }: let

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

in 

  pkgs.writeShellApplication {
    name = "rotate-wallpaper";
    runtimeInputs = [ next-wallpaper update-colors ];
    text = ''
      #!/usr/bin/env bash
      ${next-wallpaper}/bin/next-wallpaper
      ${update-colors}/bin/update-colors
    '';
  }