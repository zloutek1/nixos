{ lib, config, pkgs, ... }: {
 
  # killall Dock to make them have effect
  # https://github.com/LnL7/nix-darwin/blob/master/modules/system/defaults/dock.nix
  system.defaults.dock = {
    autohide = true;
    
    # most recently used spaces
    mru-spaces = false;
    
    persistent-apps = [
      "/System/Applications/Launchpad.app"
      "${pkgs.obsidian}/Applications/Obsidian.app"
      "${pkgs.kitty}/Applications/Kitty.app"
    ];
  };

}