{ config, lib, pkgs, ... }: 

{
  config = lib.mkIf config.services.mako.enable {

    services.mako = {
      # enable = true;
      package = pkgs.unstable.mako;
      
      settings = {
        actions = true;
        anchor = "top-right";
        borderRadius = 8;
        borderSize = 1;
        defaultTimeout = 10000;
        #font = "${theme.fonts.default.name}";
        #iconPath = "${theme.iconTheme.iconPath}";
        icons = true;
        layer = "overlay";
        maxVisible = 3;
        padding = "10";
        width = 300;

        include = "~/.config/mako/colors";
      };
    };

    home.packages = with pkgs; [
      libnotify # provides notify-send
    ];

  };
}