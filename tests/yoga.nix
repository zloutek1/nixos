{ lib, config }:
let
  identity = import ../users/tomas/identity.nix;
in
{
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
