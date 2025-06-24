{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    
    nix-darwin = {
    	url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
	    inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };

    nix-std = {
      url = "github:chessai/nix-std";
    };

    nvchad4nix = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let

      lib = import ./lib/default.nix { inherit inputs; };
      nixosModules = lib.discoverModules ./modules/nixos;
      darwinModules = lib.discoverModules ./modules/darwin;
      homeModules = lib.discoverModules ./modules/home-manager;

    in
    {
      inherit lib nixosModules darwinModules homeModules;

      nixosConfigurations = {
        yoga = lib.mkNixosSystem {
          system = "x86_64-linux";
          hostname = "yoga";
          users = [ "tomas" ];
        };
      };
      darwinConfigurations = {
        mac-mini = lib.mkDarwinSystem {
          system = "aarch64-darwin";
          hostname = "mac-mini";
          users = [ "tomas" ];
        };
      };

    };
}
