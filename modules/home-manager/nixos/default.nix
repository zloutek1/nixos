{ self, ... }: {

  imports = with self.homeModules.nixos; [
    cursor
    dark-theme
    xdg
    wallchange.default
    hyprland.default
    wofi.default
    waybar.default
    wlogout
    mako
    batsignal
    unstable.keepassxc
  ];

}