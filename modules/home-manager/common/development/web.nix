{ config, lib, pkgs, ... }: {
  options = {
    programs.development.web = {
      enable = lib.mkEnableOption "enable web development";
    };
  };

  config = lib.mkIf config.programs.development.web.enable {
    home.packages = with pkgs; [
      nodejs
      typescript
    ];

    programs.vscode.profiles.default.extensions = with pkgs.vscode-marketplace; [
      yoavbls.pretty-ts-errors
      dbaeumer.vscode-eslint
    ];
  };
}