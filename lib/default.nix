{ inputs, self }:

{
    mkNixosSystem = import ./mkNixosSystem.nix;
    getHomeDirectory = import ./getHomeDirectory.nix { inherit inputs self; };
}