# Every host is built here. Each host's own default.nix imports the modules it uses.
{ inputs, self, ... }:
let
  mkArgs = hostname: username: {
    inherit inputs self hostname username;
    users = [ username ];
  };
in
{
  flake.nixosConfigurations.yoga = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = mkArgs "yoga" "tomas";
    modules = [ ./yoga ];
  };

  flake.darwinConfigurations.mac-mini = inputs.nix-darwin.lib.darwinSystem {
    specialArgs = mkArgs "mac-mini" "tomas";
    modules = [ ./mac-mini ];
  };
}
