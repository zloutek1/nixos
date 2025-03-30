{ config, pkgs, ... }: {

    imports = [
        ./hardware.nix
        ../../modules/hardware/lenovo/yoga/16IMH9
        ../../modules/greetd.nix
        ../../modules/pipewire.nix
        ../../modules/hyprland.nix
    ];

}