{
  config,
  pkgs,
  inputs,
  username,
  hostname,
  users,
  self,
  ...
}:
{

  imports = [
    ./hardware.nix
    ../../overlays
    ../../modules/nixos/common.nix
    ../../modules/nixos/grub.nix
    ../../modules/nixos/sddm.nix
    ../../modules/nixos/pipewire.nix
    ../../modules/nixos/bluetooth.nix
    ../../modules/nixos/hyprland.nix
    ../../modules/nixos/network.nix
    ../../modules/nixos/syncthing.nix
    ../../users/tomas/nixos.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = {
      inherit inputs self hostname username users;
    };
    users.${username}.imports = [
      ../../modules/home-manager/common
      ../../modules/home-manager/nixos
      ../../users/tomas/yoga.nix
    ];
  };

  networking.hostName = "yoga";
  system.stateVersion = "24.11";

  # since laptop has dualboot with windows
  time.hardwareClockInLocalTime = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "compose:ralt";
  };

  powerManagement.cpuFreqGovernor = "performance";

}
