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

    #services.actkbd = {
    #    enable = true;
    #    bindings = [
    #        { keys = [ 113 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l tomas -c 'amixer -q set Master toggle'"; }
    #        { keys = [ 114 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l tomas -c 'amixer -q set Master 5%- unmute'"; }
    #        { keys = [ 115 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l tomas -c 'amixer -q set Master 5%+ unmute'"; }
    #    ];
    #};

}