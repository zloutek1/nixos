{ config, lib, pkgs, inputs, ... }: 

lib.mkIf pkgs.stdenv.isLinux {

  disabledModules = [ 
    "${inputs.home-manager}/modules/programs/keepassxc.nix"
    "${inputs.home-manager}/modules/programs/chromium.nix"
  ];
  imports = [ 
    "${inputs.home-manager-unstable}/modules/programs/keepassxc.nix"
    "${inputs.home-manager-unstable}/modules/programs/chromium.nix"
  ];

  options = {
    programs.keepassxc = {
      enable = lib.mkEnableOption "cursor theme configuration";
    };
  };

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