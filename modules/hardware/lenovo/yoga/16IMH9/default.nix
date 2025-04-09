{ config, lib, pkgs, ... }: {

    imports = [
        ./graphics.nix
        ./audio.nix
    ];

    services = {
        power-profiles-daemon.enable = lib.mkDefault true;

        # Add udev rules to switch profiles based on AC power
        udev.extraRules = lib.mkIf config.services.power-profiles-daemon.enable ''
            ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTRS{online}=="0", RUN+="${lib.getExe pkgs.power-profiles-daemon} set power-saver"
            ACTION=="change", SUBSYSTEM=="power_supply", ATTRS{type}=="Mains", ATTRS{online}=="1", RUN+="${lib.getExe pkgs.power-profiles-daemon} set balanced"
        '';

        # Enable UPower (needed by some DEs/tools, though power-profiles-daemon is primary)
        upower.enable = lib.mkDefault true;
    };

}