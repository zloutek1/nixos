{ self, ... }: {

  imports = [
    self.homeModules.preferences
  ];

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

}