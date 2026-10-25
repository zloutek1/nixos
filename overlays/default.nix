{ inputs, ... }: let 

  nixpkgs-unstable = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
    };
  };

  home-manager-unstable = final: prev: {
    hm.unstable = import inputs.home-manager-unstable {
      system = final.stdenv.hostPlatform.system;
    };
  };

in {

  nixpkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default
    nixpkgs-unstable
    home-manager-unstable
    (import ./elegant-grub-theme.nix)
  ];

}