{
  config,
  pkgs,
  self,
  username,
  ...
}:
{

  imports = [
    ./hardware.nix
    self.nixosModules.grub
    self.nixosModules.sddm
    self.nixosModules.pipewire
    self.nixosModules.bluetooth
    self.nixosModules.hyprland
    self.nixosModules.users
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
