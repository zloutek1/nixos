{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkMerge [
    {
      boot.kernel.sysctl = {
        "kernel.nmi_watchdog" = lib.mkDefault 0;
      };

      services = {
        power-profiles-daemon.enable = lib.mkDefault true;

        udev.extraRules = lib.mkIf config.services.power-profiles-daemon.enable ''
          ## Automatically switch power profiles based on AC power status.
          ACTION=="change", SUBSYSTEM=="power_supply", ATTRS{type}=="Mains", ATTRS{online}=="0", RUN+="${lib.getExe pkgs.power-profiles-daemon} set power-saver"
          ACTION=="change", SUBSYSTEM=="power_supply", ATTRS{type}=="Mains", ATTRS{online}=="1", RUN+="${lib.getExe pkgs.power-profiles-daemon} set balanced"
        '';

        upower.enable = lib.mkDefault true;
      };
    }

    (lib.mkIf (lib.elem "kvm-intel" config.boot.kernelModules) {
      powerManagement.powertop.enable = true;
      services.thermald.enable = true;
    })

    (lib.mkIf (lib.elem "nvidia" config.services.xserver.videoDrivers) {
      hardware.nvidia = {
        dynamicBoost.enable = lib.mkDefault true;

        powerManagement = {
          enable = lib.mkForce true;
          finegrained = lib.mkForce true;
        };

        prime.offload = {
          # Remember to define nvidiaBusId and intelBusId/amdBusId in config.hardware.nvidia.prime.
          enable = true;
          enableOffloadCmd = true;
        };
      };
    })
  ];
}