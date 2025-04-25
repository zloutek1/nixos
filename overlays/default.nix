{ inputs, ... }: let 

  nixpkgs-unstable = import ./nixpkgs-unstable.nix { inherit inputs; };

in {

  nixpkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default
    nixpkgs-unstable
  ];

}