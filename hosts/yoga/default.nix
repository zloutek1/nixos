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
  ];

  networking.hostName = "yoga";
  system.stateVersion = "24.11";

  # since laptop has dualboot with windows
  time.hardwareClockInLocalTime = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "compose:ralt";
  };

}
