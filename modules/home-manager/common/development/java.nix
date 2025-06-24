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

    programs.vscode.profiles.default.extensions = with pkgs.vscode-marketplace; [
      vscjava.vscode-java-pack
      oracle.oracle-java
      redhat.java
    ];
  };
}