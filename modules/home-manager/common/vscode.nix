{ pkgs, ... }: {

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = true;

      extensions = with pkgs.vscode-marketplace; [
        bbenoist.nix
        jnoortheen.nix-ide
      ];
    };
  };

}