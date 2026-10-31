# Every overlay, applied on every host. Overlays are lazy, so a package that
# only one host uses costs the others nothing.
{ inputs, ... }:
{

  nixpkgs.overlays = [
    # pkgs.unstable.<name> for single packages from nixos-unstable.
    (final: _prev: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (final.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };
    })

    # Our own packages from pkgs/.
    (final: _prev: {
      elegant-grub-theme = final.callPackage ../pkgs/elegant-grub-theme.nix { };
    })
  ];

}
