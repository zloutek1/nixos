{ pkgs, ... }: {

  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;

    userSettings = {
    #  "workbench.colorTheme" = "Dracula Theme";
    };

    extensions = with pkgs.vscode-marketplace; [
      bbenoist.nix
      jnoortheen.nix-ide
    ];
  };

}