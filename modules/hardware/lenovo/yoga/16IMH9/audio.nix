{ config, lib, pkgs,... }: {
    
    # --- Speaker Fix (Hardware Quirk for Yoga Pro 9i Gen 9 / 16IMH9) ---

    # Ensure I2C kernel module is loaded
    boot.kernelModules = [ "i2c-dev" ];

    # Blacklist the problematic default ALSA codec module
    boot.blacklistedKernelModules = [ "snd_hda_scodec_tas2781_i2c" ];

    # Define the systemd service to run the fix script
    systemd = {
        services.yoga-speaker-fix = let
            yoga-speaker-fix = pkgs.writeShellApplication {
                name = "yoga-speaker-fix";

                runtimeInputs = with pkgs; [
                    alsa-utils
                    gawk
                    gnugrep
                    gnused
                    i2c-tools
                    kmod
                    uutils-coreutils-noprefix
                ];

                text = builtins.readFile ./yoga-speaker-fix.sh;
            };
        in {
            enable = true;
            description = "Apply I2C configuration for Yoga Pro 9i speakers";
            after = [ "graphical.target" "sound.target" ];
            wantedBy = [ "graphical.target" ];
            requires = [ "sound.target" ];

            serviceConfig = {
                Type = "oneshot";
                ExecStart = "${lib.getExe yoga-speaker-fix}";
                StandardOutput = "journal";
                StandardError = "journal";
            };
        };

        timers = {
            yoga-speaker-fix = {
                enable = true;
                timerConfig.OnBootSec = "30s"; # Runs 30 seconds after boot
                partOf = [ "yoga-speaker-fix.service" ];
            };
        };
    };
    
}