{config, lib, settings, pkgs, ...}: {

    environment.systemPackages = with pkgs; [ cudatoolkit ];

    hardware.graphics.enable = true;
    #services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
        modesetting.enable = true;

        powerManagement = {
            enable = false;
            finegrained = false;
        };

        open = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    boot.kernelParams = [
        "nvidia-drm.modeset=1"
        "nvidia-drm.fbdev=1"
    ];

}