{ self, ... }: {

  imports = [
    self.commonModules.preferences
  ];

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

}