# `nix flake check` runs everything here:
#   - <host>-invariants: fast, eval-only assertions about each host's config
#     (tests/common.nix for every host, plus tests/<host>.nix). Every system
#     runs every host's, so the Mac checks yoga too.
#   - <host>-build: builds the whole system, only on a machine of that platform.
#   - formatting: every .nix file is formatted with nixfmt (`nix fmt` fixes it).
#   - deadnix: no unused function arguments or let bindings (`deadnix -e` fixes it).
# `nix flake check --no-build` evaluates everything without building.
{ self, lib, ... }:
let
  hosts = self.nixosConfigurations // self.darwinConfigurations;

  # lib.runTests takes { testName = { expr; expected; }; } and returns the failures.
  invariants =
    pkgs: name: host:
    let
      args = {
        inherit lib;
        inherit (host) config;
      };
      failures = lib.runTests (import ./common.nix args // import ./${name}.nix args);
    in
    if failures == [ ] then
      pkgs.runCommand "${name}-invariants" { } "touch $out"
    else
      throw "${name}: failing invariants:\n${lib.generators.toPretty { } failures}";

  # Runs a linter over every .nix file in the repo.
  lint =
    pkgs: name: tool: script:
    pkgs.runCommand name
      {
        nativeBuildInputs = [ tool ];
        src = lib.fileset.toSource {
          root = ../.;
          fileset = lib.fileset.fileFilter (file: file.hasExt "nix") ../.;
        };
      }
      ''
        cd $src
        ${script}
        touch $out
      '';
in
{
  perSystem =
    { pkgs, system, ... }:
    {
      checks =
        lib.mapAttrs' (name: host: lib.nameValuePair "${name}-invariants" (invariants pkgs name host)) hosts
        // lib.mapAttrs' (name: host: lib.nameValuePair "${name}-build" host.config.system.build.toplevel) (
          lib.filterAttrs (_: host: host.pkgs.stdenv.hostPlatform.system == system) hosts
        )
        // {
          formatting =
            lint pkgs "formatting" pkgs.nixfmt
              "find . -name '*.nix' -print0 | xargs -0 nixfmt --check";
          deadnix = lint pkgs "deadnix" pkgs.deadnix "deadnix --fail .";
        };
    };
}
