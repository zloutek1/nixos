{ config, lib, pkgs, ... }: {
  options = {
    programs.development.java = {
      enable = lib.mkEnableOption "enable java development";
    };
  };

  config = lib.mkIf config.programs.development.java.enable {
    home.packages = with pkgs; [
      jdk21_headless
    ];
  };
}