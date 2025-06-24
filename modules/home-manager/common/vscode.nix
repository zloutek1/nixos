{ pkgs, ... }: {

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      
      userSettings = {
        #  "workbench.colorTheme" = "Dracula Theme";
      };

      extensions = with pkgs.vscode-marketplace; [
        bbenoist.nix
        jnoortheen.nix-ide
      ];
    };
  };

}