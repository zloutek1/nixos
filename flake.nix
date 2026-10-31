{
  description = "zloutek1's hosts: yoga (NixOS) and mac-mini (nix-darwin home server)";

  inputs = {
    # ── Package sets ──
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05"; # yoga (NixOS stable)
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin"; # mac-mini
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable"; # pkgs.unstable.<name> one-offs

    # ── Flake plumbing ──
    # Module system for the flake's own outputs (perSystem, imports, flake.*).
    flake-parts.url = "github:hercules-ci/flake-parts";

    # ── System managers ──
    # macOS system configuration (mac-mini).
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    # Per-user dotfiles and programs (yoga).
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ── Extras used by single modules ──
    # NvChad neovim config, used by modules/home-manager/common/nvim.
    nvchad4nix = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      imports = [
        ./hosts
        ./tests
      ];

      perSystem =
        { pkgs, ... }:
        {
          formatter = pkgs.nixfmt;
        };
    };
}
