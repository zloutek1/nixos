{ config, lib, pkgs, inputs, ... }: {

  disabledModules = [ 
    "${inputs.home-manager}/modules/programs/keepassxc.nix"
    "${inputs.home-manager}/modules/programs/chromium.nix"
  ];
  imports = [ 
    "${inputs.home-manager-unstable}/modules/programs/keepassxc.nix"
    "${inputs.home-manager-unstable}/modules/programs/chromium.nix"
  ];

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