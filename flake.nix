{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    
    nix-darwin = {
    	url = "github:LnL7/nix-darwin";
	    inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
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
      nixosModules = lib.discoverModules { path = ./modules/nixos; };
      darwinModules = lib.discoverModules { path = ./modules/darwin; };
      homeModules = lib.discoverModules { path = ./modules/home-manager; } 
        // { unstable = lib.discoverModules { path = ./modules/home-manager/unstable; }; };

    in
    {
      inherit lib nixosModules homeModules;

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
