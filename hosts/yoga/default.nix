{ config, pkgs, ... }: {

    imports = [
        ./hardware.nix
        ../../modules/hardware/lenovo/yoga/16IMH9
        ../../modules/common.nix
        ../../modules/greetd.nix
        ../../modules/pipewire.nix
        ../../modules/hyprland
    ];

    networking.hostName = "yoga";

}