{ self, ... }: {

  imports = with self.homeModules.common; [
    zsh
    zoxide
    git
    kitty.default
    rofi.default
    nvim.default
    vscode
    unstable.syncthing
    unstable.chromium
  ];

}