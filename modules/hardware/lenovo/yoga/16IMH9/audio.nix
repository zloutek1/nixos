{ config, lib, pkgs,... }: {
    
    # --- Speaker Fix (Hardware Quirk for Yoga Pro 9i Gen 9 / 16IMH9) ---

    # 1. Install required tools for the fix script
    environment.systemPackages = with pkgs; [
        i2c-tools # For i2cdetect, i2cset
        kmod      # For modprobe
        util-linux # Provides logger (used in original script source)
    ];

    # 2. Ensure I2C kernel module is loaded
    boot.kernelModules = [ "i2c-dev" ];

    # 3. Blacklist the problematic default ALSA codec module
    boot.blacklistedKernelModules = [ "snd_hda_scodec_tas2781_i2c" ];

    # 4. Define the systemd service to run the fix script
    systemd = {
        services.yoga-speakers-fix = let
            yoga-speakers-fix = pkgs.writeShellApplication {
                name = "yoga-speakers-fix";

                runtimeInputs = with pkgs; [
                    alsa-utils
                    gawk
                    gnugrep
                    gnused
                    i2c-tools
                    kmod
                    uutils-coreutils-noprefix
                ];

                text = builtins.readFile ./yoga-speakers-fix.sh;
            };
        in {
            enable = true;
            description = "Apply I2C configuration for Yoga Pro 9i speakers";
            # Run after sound system is ready and after resuming from sleep/hibernate
            after = [ "sound.target" "suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target" ];
            wantedBy = [ "multi-user.target" "sleep.target" ]; # Run on boot and wake
            requires = [ "sound.target" ]; # Dependency

            serviceConfig = {
                Type = "oneshot";
                ExecStart = "${lib.getExe yoga-speakers-fix}";
                StandardOutput = "journal"; # Log script output to systemd journal
                StandardError = "journal";
                User = "root"; # I2C access requires root privileges 
            };
        };

        timers = {
            yoga-speakers = {
                enable = true;
                timerConfig.OnBootSec = "30s"; # Runs 30 seconds after boot
                partOf = ["yoga-speakers-fix.service"];
            };
        };
    };
    
}