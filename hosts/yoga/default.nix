{ config, pkgs, ... }: {

    imports = [
        ./hardware.nix
        ../../modules/common.nix
        ../../modules/grub.nix
        ../../modules/greetd.nix
        ../../modules/pipewire.nix
        ../../modules/bluetooth.nix
        ../../modules/hyprland.nix
    ];



    networking.networkmanager.enable = true;
    environment.systemPackages = with pkgs; [
        networkmanagerapplet
    ];

    # since laptop has dualboot with windows
    time.hardwareClockInLocalTime = true;

    services.xserver.xkb = {
        layout = "us";
        variant = "";
    };

}
