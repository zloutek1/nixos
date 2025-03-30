{ config, pkgs, ... }: {

    imports = [
        ./hardware.nix
        ../../modules/hardware/lenovo/yoga/16IMH9
        ../../modules/common.nix
        ../../modules/greetd.nix
        ../../modules/pipewire.nix
        ../../modules/hyprland
    ];

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.networkmanager.enable = true;

    services.xserver.xkb = {
        layout = "us";
        variant = "";
    };

}