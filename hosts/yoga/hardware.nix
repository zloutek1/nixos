{ config, lib, modulesPath, self, ... }: {

    imports = [ 
        "${modulesPath}/installer/scan/not-detected.nix"
        "${self}/modules/hardware/lenovo/yoga/16IMH9"
    ];

    boot = {
        initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
        initrd.kernelModules = [ ];
        kernelModules = [ "kvm-intel" ];
        extraModulePackages = [ ];
    };

    fileSystems."/" = { 
        device = "/dev/disk/by-uuid/10fbd252-5737-4751-9b9b-f3b96259341e";
        fsType = "ext4";
    };
    fileSystems."/boot" = { 
        device = "/dev/disk/by-uuid/2873-228A";
        fsType = "vfat";
        options = [ "fmask=0077" "dmask=0077" ];
    };
    swapDevices = [ ];

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

}