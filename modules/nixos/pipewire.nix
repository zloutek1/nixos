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
      };
    };
  };

  users.users = lib.genAttrs users (username: {
    extraGroups = [ "realtime" ];
  });

  environment.systemPackages = with pkgs; [
    pavucontrol
  ];

}
