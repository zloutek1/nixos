{
  config,
  pkgs,
  self,
  username,
  ...
}:
{

  imports = with self.nixosModules; [
    ./hardware.nix
    grub
    sddm
    pipewire
    bluetooth
    hyprland
    users
    network
    syncthing
  ];

  networking.hostName = "yoga";
  system.stateVersion = "24.11";

  hardware.enableRedistributableFirmware = true;

  # since laptop has dualboot with windows
  time.hardwareClockInLocalTime = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "compose:ralt";
  };

}
