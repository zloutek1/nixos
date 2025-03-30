{ lib, pkgs, ... }: {
    
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
          wantedBy = ["timers.target"];
        };
      };
    };

}
