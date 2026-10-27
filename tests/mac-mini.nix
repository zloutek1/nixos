# Things the home server must keep doing whatever else changes.
{ lib, config }:
let
  identity = import ../users/tomas/identity.nix;
  sshd = config.services.openssh.extraConfig;
in
{
  testSshKeyOnly = {
    expr = lib.hasInfix "PasswordAuthentication no" sshd;
    expected = true;
  };
  testSshHasAKey = {
    expr = config.users.users.tomas.openssh.authorizedKeys.keys != [ ];
    expected = true;
  };
  testSshOnlyTomas = {
    expr = lib.hasInfix "AllowUsers tomas" sshd;
    expected = true;
  };
  testFirewallStealth = {
    expr = with config.networking.applicationFirewall; enable && enableStealthMode;
    expected = true;
  };
  testNeverSleeps = {
    expr = config.power.sleep.computer;
    expected = "never";
  };
  testRestartsAfterPowerFailure = {
    expr = config.power.restartAfterPowerFailure;
    expected = true;
  };
  # An unattended install reboots into the FileVault pre-boot screen.
  testNoUnattendedMacOSInstall = {
    expr = config.system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates;
    expected = false;
  };
  testGitIdentity = {
    expr = lib.hasInfix "email = ${identity.email}" config.environment.etc."gitconfig".text;
    expected = true;
  };
}
