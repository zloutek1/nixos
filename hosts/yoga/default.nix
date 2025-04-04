{ config, pkgs, ... }: {

    imports = [
        ./hardware.nix
        ../../modules/common.nix
        ../../modules/greetd.nix
        ../../modules/pipewire.nix
        ../../modules/bluetooth.nix
        ../../modules/hyprland.nix
    ];

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.networkmanager.enable = true;
    environment.systemPackages = with pkgs; [
        networkmanagerapplet
    ];

    services.xserver.xkb = {
        layout = "us";
        variant = "";
    };

}
