{ config, lib, pkgs, inputs, ... }: 
{

  disabledModules = [ "${inputs.home-manager}/modules/services/syncthing.nix" ];
  imports = [ "${inputs.home-manager-unstable}/modules/services/syncthing.nix" ];

  config = lib.mkIf config.services.syncthing.enable {
    services.syncthing = {
      # enable = true;
      tray = {
        enable = true;
      };

      overrideDevices = true;
      overrideFolders = true;

      settings = {
        devices = {
          "mac-mini" = {
            id = "NHUD4JQ-L5TBR4T-HJGKWMF-2AICEWV-IE5U5I5-2VWSFEJ-7ROVVFH-55YTKQ7";
          }; 
        };

        folders = {
          "/home/tomas/documents/personal" = {
            id = "life-archive";
            devices = [ "mac-mini" ];
          };

          "/home/tomas/documents/KeePassXC" = {
            id = "keepass";
            devices = [ "mac-mini" ];
          };

          "/home/tomas/projects" = {
            id = "projects";
            devices = [ "mac-mini" ];
          };
        };
      };
    };

  };
}