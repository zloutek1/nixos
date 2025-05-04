{ lib, config, ... }: {
  
  system.defaults.finder = {
    AppleShowAllFiles = true;
    AppleShowAllExtensions = true;
    QuitMenuItem = true;
    FXEnableExtensionChangeWarning = false;

    # set default column view
    FXPreferredViewStyle = "clmv";
  };

}