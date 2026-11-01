# Every host is built here. Each host's own default.nix imports the modules it uses.
# Only `inputs` is passed as a special arg; everything else is ordinary config.
{ inputs, ... }:
{
  flake.nixosConfigurations.yoga = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [ ./yoga ];
  };

  # The NixOS guest that runs every service, under Lima VZ on mac-mini.
  flake.nixosConfigurations.homelab = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [ ./homelab ];
  };

  flake.darwinConfigurations.mac-mini = inputs.nix-darwin.lib.darwinSystem {
    specialArgs = { inherit inputs; };
    modules = [ ./mac-mini ];
  };
}
