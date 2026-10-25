# pkgs.unstable.<name> for single packages from nixos-unstable.
{ inputs, ... }: {

  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (final.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };
    })
  ];

}
