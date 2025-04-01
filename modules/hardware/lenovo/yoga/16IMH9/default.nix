{ lib, pkgs, inputs, ... }: {

    imports = [
        ../../../cpu/intel.nix
        ../../../gpu/intel.nix
        ../../../gpu/nvidia.nix
        ../../../profiles/laptop.nix
    ];

    boot = {
        extraModprobeConfig = ''
            # options snd_hda_intel power_save_controller=N
            # options snd_hda_intel power_save=0
            blacklist snd_hda_scodec_tas2781_i2c # Works initially, but then bass speakers stop working.
        '';

        initrd.availableKernelModules = ["thunderbolt" "nvme" "sdhci_pci"];
        kernelModules = ["i2c-dev"];
        kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.11") (lib.mkDefault pkgs.linuxPackages_latest);
    };

    hardware = {
        i2c.enable = true;
        sensor.iio.enable = true;

        nvidia = {
            prime = {
                intelBusId = "PCI:0:2:0";
                nvidiaBusId = "PCI:1:0:0";
            };
        };
    };

    systemd = {
        services.turn-on-speakers = let
            turn-on-speakers = pkgs.writeShellApplication {
                name = "turn-on-speakers";

                runtimeInputs = with pkgs; [
                    alsa-utils
                    gawk
                    gnugrep
                    gnused
                    i2c-tools
                    kmod
                    uutils-coreutils-noprefix
                ];

                text = builtins.readFile ./turn-on-speakers.sh;
            };
        in {
            # Due to bugs in the snd_hda_scodec_tas2781_i2c module, the best way to have functional speakers is to run a small script to turn the bass speakers on via i2c.
            enable = true;

            after = [
                "graphical.target"
                "sound.target"
            ];

            requires = ["sound.target"];

            serviceConfig = {
                Type = "oneshot";
                ExecStart = "${lib.getExe turn-on-speakers}";
            };

            wantedBy = ["graphical.target"];
        };

        timers = {
            yoga-speakers = {
                enable = true;
                timerConfig.OnBootSec = "30s"; # Runs 30 seconds after boot
                partOf = ["turn-on-speakers.service"];
            };
        };
    };

}
