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
  ];

  networking.hostName = "yoga";
  system.stateVersion = "24.11";

  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];

  # since laptop has dualboot with windows
  time.hardwareClockInLocalTime = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "compose:ralt";
  };

}
