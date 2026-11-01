# Things every host must keep doing, merged into each tests/<host>.nix.
{ lib, config }:
{
  # A module warning usually means a renamed or removed option; fix it, don't let it pile up.
  testNoModuleWarnings = {
    expr = config.warnings;
    expected = [ ];
  };
  testFlakesEnabled = {
    expr = lib.all (f: lib.elem f config.nix.settings.experimental-features) [
      "nix-command"
      "flakes"
    ];
    expected = true;
  };
  # Old generations are collected, but never so fast that there's nothing to
  # roll back to. How long each host keeps them is in tests/<host>.nix.
  testGcAutomatic = {
    expr = config.nix.gc.automatic;
    expected = true;
  };
  testTimeZone = {
    expr = config.time.timeZone;
    expected = "Europe/Bratislava";
  };
}
