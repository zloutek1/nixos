{ pkgs, ... }: {

  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = true;

    userSettings = {
    #  "workbench.colorTheme" = "Dracula Theme";
    };

    extensions = with pkgs.vscode-extensions.vscode-marketplace; [

    ];
  };

}