{ self, ... }: {

  imports = with self.homeModules; [
    cursor
    dark-theme
    xdg
    zsh
    zoxide
    git
    kitty
    nvim
    wallchange
    hyprland
    wofi
    rofi
    waybar
    wlogout
    mako
    batsignal
    vscode
    unstable.syncthing
    unstable.keepassxc
    unstable.chromium
  ];

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

}