{ pkgs, lib, users, ... }:
{

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;

    extraConfig.pipewire = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 1024;
        "default.clock.max-quantum" = 8192;  # Allow larger buffers when needed
        "core.daemon" = true;                # Run as a background process
        "core.clock.min-quantum" = 1024;     # Consistent with default.clock values
      };
      "context.modules" = [
        {
          name = "libpipewire-module-rtkit";
          args = {
            "nice.level" = -15;
            "rt.prio" = 88;
            "rt.time.soft" = 200000;
            "rt.time.hard" = 200000;
          };
          flags = [ "ifexists" "nofail" ];
        }
      ];
    };
    extraConfig.pipewire-pulse = {
      "context.exec" = [
        { path = "pactl"; args = "set-default-sink alsa_output.pci-0000_00_1f.3.analog-stereo"; }
      ];
      "stream.properties" = {
        "node.latency" = "32/48000";
        "resample.quality" = 4;
      };
    };
  };

  users.users = lib.genAttrs users (username: {
    extraGroups = [ "realtime" "audio" ];
  });

  environment.systemPackages = with pkgs; [
    pavucontrol
    easyeffects    # Add this for additional audio control
    helvum         # PipeWire patchbay
  ];

}
