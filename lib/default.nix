{ inputs, self, lib }:

{
  mkNixosSystem = import ./mkNixosSystem.nix { inherit inputs self lib; };
  getHomeDirectory = import ./getHomeDirectory.nix;
  discoverModules = import ./discoverModules.nix { inherit lib; };
}
