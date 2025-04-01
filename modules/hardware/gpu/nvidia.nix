{config, lib, ...}: {

    boot = {
        extraModulePackages = [];
        initrd.kernelModules = ["nvidia"];
        kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];
    };

    # Enable opengl
    hardware.opengl = {
        enable = true;
    };

    # Load nvidia driver for xorg and wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
        open = false;

        modesetting.enable = true;
        
        powerManagement.enable = lib.mkDefault false;
        powerManagement.finegrained = lib.mkDefault false;
        
        nvidiaSettings = true;
        
        package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

}