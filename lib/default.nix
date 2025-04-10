{ inputs, self }:

{
  mkNixosSystem = import ./mkNixosSystem.nix { inherit inputs self; };
  getHomeDirectory = import ./getHomeDirectory.nix;
  discoverModules = import ./discoverModules.nix { lib = inputs.nixpkgs.lib; };
}
