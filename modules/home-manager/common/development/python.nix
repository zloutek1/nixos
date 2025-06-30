{ config, lib, pkgs, ... }: {
  options = {
    programs.development.python = {
      enable = lib.mkEnableOption "enable python development";
    };
  };

  config = lib.mkIf config.programs.development.python.enable {
    home.packages = with pkgs; [
      python311
    ];

    programs.vscode.profiles.default.extensions = with pkgs.vscode-marketplace; [
      
    ];
  };
}