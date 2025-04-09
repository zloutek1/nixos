{ inputs, self }:

{
    mkNixosSystem = import ./mkNixosSystem.nix { inherit inputs self; };
    getHomeDirectory = import ./getHomeDirectory.nix;
}