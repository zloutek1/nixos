{ lib, config }:
let
  identity = import ../users/tomas/identity.nix;
  hm = config.home-manager.users.tomas;
in
{
  testGcKeepsAMonth = {
    expr = config.nix.gc.options;
    expected = "--delete-older-than 30d";
  };
  testNoHomeManagerWarnings = {
    expr = hm.warnings;
    expected = [ ];
  };
  # The laptop's copies of the shared folders sync with the home server.
  testSyncsWithMacMini = {
    expr = lib.all (folder: folder.devices == [ "mac-mini" ]) (
      lib.attrValues hm.services.syncthing.settings.folders
    );
    expected = true;
  };
  testAudioGroups = {
    expr = lib.all (g: lib.elem g config.users.users.tomas.extraGroups) [
      "audio"
      "realtime"
    ];
    expected = true;
  };
  testGitIdentity = {
    expr = config.home-manager.users.tomas.programs.git.settings.user.email;
    expected = identity.email;
  };
  # Dual boot with Windows.
  testHardwareClockLocal = {
    expr = config.time.hardwareClockInLocalTime;
    expected = true;
  };
}
