{ config, lib, pkgs, ... }: {
  options = {
    programs.development.godot = {
      enable = lib.mkEnableOption "enable godot development";
    };
  };

  config = lib.mkIf config.programs.development.godot.enable {
    home.packages = with pkgs; [
      godot
    ];
  };
}