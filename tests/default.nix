# `nix flake check` runs everything here:
#   - <host>-invariants: fast, eval-only assertions about each host's config
#     (tests/<host>.nix). Every system runs every host's, so the Mac checks yoga too.
#   - <host>-build: builds the whole system, only on a machine of that platform.
# `nix flake check --no-build` evaluates everything without building.
{ self, lib, ... }:
let
  hosts = self.nixosConfigurations // self.darwinConfigurations;

  # lib.runTests takes { testName = { expr; expected; }; } and returns the failures.
  invariants =
    pkgs: name: host:
    let
      failures = lib.runTests (
        import ./${name}.nix {
          inherit lib;
          inherit (host) config;
        }
      );
    in
    if failures == [ ] then
      pkgs.runCommand "${name}-invariants" { } "touch $out"
    else
      throw "${name}: failing invariants:\n${lib.generators.toPretty { } failures}";
in
{
  perSystem =
    { pkgs, system, ... }:
    {
      checks =
        lib.mapAttrs' (name: host: lib.nameValuePair "${name}-invariants" (invariants pkgs name host)) hosts
        // lib.mapAttrs' (name: host: lib.nameValuePair "${name}-build" host.config.system.build.toplevel) (
          lib.filterAttrs (_: host: host.pkgs.stdenv.hostPlatform.system == system) hosts
        );
    };
}
