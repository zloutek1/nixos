{ self, pkgs, lib, isLinux, isDarwin, ... }: {

  imports = with self.homeModules; [
    cursor
    dark-theme
    zsh
    zoxide
    git
    kitty
    rofi
    nvim
    vscode
    unstable.syncthing
    unstable.chromium
  ]
  ++ lib.optionals isLinux [
    xdg
    wallchange
    hyprland
    wofi
    waybar
    wlogout
    mako
    batsignal
    unstable.keepassxc
  ]
  ++ lib.optionals isDarwin [

  ];

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

}