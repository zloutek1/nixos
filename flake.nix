{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: let
    
    lib = import ./lib/default.nix { inherit inputs self; };
  
  in {
    
    lib = lib;

    nixosConfigurations = {
      yoga = lib.mkNixosSystem {
        system = "x86_64-linux";
        hostname = "yoga";
        username = "tomas";
      };
    };
    
  };
}
