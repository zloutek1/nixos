# Things the home server must keep doing whatever else changes.
{ lib, config }:
let
  identity = import ../users/tomas/identity.nix;
  sshd = config.services.openssh.extraConfig;
  postActivation = config.system.activationScripts.postActivation.text;
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
  testGitUsesGhForGitHub = {
    expr = lib.hasInfix "gh auth git-credential" config.environment.etc."gitconfig".text;
    expected = true;
  };
  testPrimaryUserTomas = {
    expr = config.system.primaryUser;
    expected = "tomas";
  };
  # Without it, the T7 stays unmounted after a pre-boot SSH unlock.
  testMountsT7 = {
    expr = config.launchd.daemons ? mount-t7;
    expected = true;
  };
  # The hand-written defaults that nix-darwin has no options for.
  testPowerNapOff = {
    expr = lib.hasInfix "pmset -a powernap 0" postActivation;
    expected = true;
  };
  testAirPlayReceiverOff = {
    expr = lib.hasInfix "AirplayReceiverEnabled -bool false" postActivation;
    expected = true;
  };
  testWifiRealMac = {
    expr = lib.hasInfix "PrivateMACAddressModeUserSetting" postActivation;
    expected = true;
  };
  testNoHomeManager = {
    expr = config ? home-manager;
    expected = false;
  };
  testGcKeepsTwoWeeks = {
    expr = config.nix.gc.options;
    expected = "--delete-older-than 14d";
  };
  # The limactl copy holds Full Disk Access; only root and homelab may run it.
  testTomasNotInHomelab = {
    expr = config.users.groups.homelab.members;
    expected = [ "homelab" ];
  };
  testVmRunsAsHomelab = {
    expr = config.launchd.daemons.homelab-vm.serviceConfig.UserName;
    expected = "homelab";
  };
  # Lima's host agent outlives a dead VM, so launchd alone never restarts it.
  testHasVmWatchdog = {
    expr = config.launchd.daemons ? homelab-watchdog;
    expected = true;
  };
  # A broken or compromised guest can add snapshots, never delete them.
  testBackupRepoAppendOnly = {
    expr = lib.elem "--append-only" config.launchd.daemons.rest-server.serviceConfig.ProgramArguments;
    expected = true;
  };
  testRestServerLocalOnly = {
    expr = lib.elem "127.0.0.1:8000" config.launchd.daemons.rest-server.serviceConfig.ProgramArguments;
    expected = true;
  };
}
