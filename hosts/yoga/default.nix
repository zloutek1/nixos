{ config, pkgs, self, ... }: {

    imports = [
        ./hardware.nix
        self.nixosModules.grub
        self.nixosModules.sddm
        self.nixosModules.pipewire
        self.nixosModules.bluetooth
        self.nixosModules.hyprland
    ];

    networking.hostName = "yoga";
    system.stateVersion = "24.11";

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
