{ self, ... }: {

  imports = with self.homeModules.nixos; [
    #cursor
    #dark-theme
    #xdg
    #wallchange
    #hyprland
    #wofi
    #waybar
    #wlogout
    #mako
    #batsignal
    #unstable.keepassxc
  ];

}