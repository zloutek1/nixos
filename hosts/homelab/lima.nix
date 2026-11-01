# What makes this a Lima guest: nixos-lima (lima-init, the guest agent, Lima's
# own login user), the T7 share and Rosetta.
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  share = import ./share.nix;
  # Lima's virtiofs tag (>= 2.2.0): "lima-" and the first 16 hex characters of
  # sha256("<host location>:<guest mountPoint>").
  tag =
    "lima-"
    + builtins.substring 0 16 (builtins.hashString "sha256" "${share.location}:${share.mountPoint}");
in
{
  imports = [ "${inputs.nixos-lima}/lima.nix" ];

  # lima-init only appends Lima's shares to /etc/fstab at boot, and a switch
  # stops every mount missing from the new fstab, so the share is declared here.
  fileSystems.${share.mountPoint} = {
    device = tag;
    fsType = "virtiofs";
    options = [
      "rw"
      "nofail"
    ];
  };
  system.activationScripts.lima-mount-tag-check.text = ''
    if [ -f /mnt/lima-cidata/user-data ] &&
       ! grep -q '${config.fileSystems.${share.mountPoint}.device},' /mnt/lima-cidata/user-data; then
      echo "WARNING: Lima's ${share.mountPoint} tag isn't ${tag}; did Lima change MountTag?" >&2
    fi
  '';

  # amd64 binaries through Apple's Rosetta share (Lima's tag is vz-rosetta).
  virtualisation.rosetta = {
    enable = true;
    mountTag = "vz-rosetta";
  };
  # A VM started without the Rosetta share must still boot.
  fileSystems."/run/rosetta".options = [ "nofail" ];

  # Kernel and systemd output on Lima's serialv.log.
  boot.kernelParams = [ "console=hvc0" ];
  # The LTS kernel, from the binary cache, instead of nixos-lima's latest.
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;
}
