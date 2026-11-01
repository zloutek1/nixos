# The Mac's half of the homelab: only plumbing. Every service runs in the
# NixOS guest (hosts/homelab); the Mac runs its VM, a watchdog, the backup
# repo and the operator's commands.
{
  imports = [
    ./vm.nix
    ./watchdog.nix
    ./backup.nix
    ./tools.nix
  ];

  # Builds the first aarch64-linux guest image only; after that the guest
  # builds itself. Turned off once the base image is in place.
  # The default 20 GiB disk is too small for the guest's closure plus its image.
  nix.linux-builder = {
    enable = true;
    config.virtualisation.darwin-builder.diskSize = 60 * 1024;
  };
}
