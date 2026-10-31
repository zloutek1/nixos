# Every host is built here. Each host's own default.nix imports the modules it uses.
# Only `inputs` is passed as a special arg; everything else is ordinary config.
{ inputs, ... }:
{
  flake.nixosConfigurations.yoga = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [ ./yoga ];
  };

  flake.darwinConfigurations.mac-mini = inputs.nix-darwin.lib.darwinSystem {
    specialArgs = { inherit inputs; };
    modules = [ ./mac-mini ];
  };
}
