{
  description = "zloutek1's hosts: yoga (NixOS), mac-mini (nix-darwin home server) and its homelab guest (NixOS)";

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

    # ── The homelab guest (NixOS under Lima VZ on mac-mini) ──
    # Lima itself, pinned on its own and bumped deliberately: its mount-tag
    # formula changed in 2.2.0, and hosts/homelab/lima.nix depends on it.
    nixpkgs-lima.url = "github:NixOS/nixpkgs/f05535a0efcb2134c478d1e88434fadf486d42b5";
    # The NixOS module that makes a Lima guest boot (lima-init, guest agent).
    nixos-lima = {
      url = "github:nixos-lima/nixos-lima";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ── Secrets ──
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Private: .sops.yaml and one encrypted file per host. Not a flake, so the
    # secret names stay out of this repo too. CI overrides it with tests/secrets.
    secrets = {
      url = "git+ssh://git@github.com/zloutek1/nix-secrets.git";
      flake = false;
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
