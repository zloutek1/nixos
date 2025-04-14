{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvchad4nix = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ... }@inputs:
    let

      lib = import ./lib/default.nix { inherit inputs self; };
      nixosModules = lib.discoverModules { path = ./modules/nixos; };
      homeModules = lib.discoverModules { path = ./modules/home-manager; };

    in
    {
      inherit lib nixosModules homeModules;

      nixosConfigurations = {
        yoga = lib.mkNixosSystem {
          system = "x86_64-linux";
          hostname = "yoga";
          username = "tomas";
        };
      };

    };
}
