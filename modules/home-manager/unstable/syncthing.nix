{ pkgs, inputs, ... }: {

  disabledModules = [ "${inputs.home-manager}/modules/services/syncthing.nix" ];
  imports = [ "${inputs.home-manager-unstable}/modules/services/syncthing.nix" ];

  services.syncthing = {
    enable = true;
    tray = {
      enable = true;
    };

    overrideDevices = true;
    overrideFolders = true;

    settings = {

    };
  };

}