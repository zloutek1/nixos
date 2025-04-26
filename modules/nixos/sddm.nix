{ pkgs, lib, ... }:
let
  
  sddm-astronaut = pkgs.sddm-astronaut.override {
    themeConfig = {
      AccentColor = "#FDFDFD";
    };
  };

in
{

  services.displayManager.sddm = {
    enable = true;
    package = lib.mkForce pkgs.kdePackages.sddm;
    theme = "sddm-astronaut-theme";
    extraPackages = [ sddm-astronaut ];
    wayland.enable = true;
    autoNumlock = true;
  };

  environment.systemPackages = [ sddm-astronaut ];

  systemd.services.numLockOnTty = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = lib.mkForce (pkgs.writeShellScript "numLockOnTty" ''
        for tty in /dev/tty{1..6}; do
            ${pkgs.kbd}/bin/setleds -D +num < "$tty";
        done
      '');
    };
  };

}
