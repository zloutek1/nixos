{ config, pkgs, ... }:
{

  xdg = {
    # enable = true;

    userDirs = {
      # enable = true;
      enable = config.xdg.enable && pkgs.stdenv.isLinux;
      
      desktop = "$HOME/desktop";
      download = "$HOME/downloads";
      documents = "$HOME/docs";
      templates = "$HOME/templates";
      music = "$HOME/media/music";
      videos = "$HOME/media/videos";
      pictures = "$HOME/media/pictures";
      publicShare = "$HOME/share/public";
    };
  };

}
