{ self, ... }: {

  imports = with self.homeModules.common; [
    zsh
    #zoxide
    #git
    #kitty
    #rofi
    #nvim
    #vscode
    #unstable.syncthing
    #unstable.chromium
  ];

}