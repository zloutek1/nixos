{ config, pkgs, self, ... }: {

    imports = [
        ./hardware.nix
        "${self}/modules/common.nix"
        "${self}/modules/grub.nix"
        "${self}/modules/greetd.nix"
        "${self}/modules/pipewire.nix"
        "${self}/modules/bluetooth.nix"
        "${self}/modules/hyprland.nix"
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
