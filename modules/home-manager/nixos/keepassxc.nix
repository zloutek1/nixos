{ config, lib, pkgs, ... }: {

  config = lib.mkIf config.programs.keepassxc.enable {
    programs.keepassxc = {
      #enable = true;
      package = pkgs.unstable.keepassxc;

      settings = {
        Browser.Enabled = true;

        GUI = {
          AdvancedSettings = true;
          ApplicationTheme = "dark";
          CompactMode = true;
          HidePasswords = true;
        };

        SSHAgent.Enabled = true;
      };
    };

  };
}