{ inputs }:

inputs.nixpkgs.lib.extend (final: prev:
  {
    mkNixosSystem = import ./mkNixosSystem.nix { inherit inputs; self = inputs.self; lib = final; };
    getHomeDirectory = import ./getHomeDirectory.nix;
    discoverModules = import ./discoverModules.nix { lib = final; };
    mkSelectionType = import ./mkSelectionType.nix { lib = final; };
  }
  // inputs.home-manager.lib
)

