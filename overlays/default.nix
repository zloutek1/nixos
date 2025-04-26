{ inputs, ... }: let 

  nixpkgs-unstable = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
    };
  };

  home-manager-unstable = final: prev: {
    hm.unstable = import inputs.home-manager-unstable {
      system = final.system;
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