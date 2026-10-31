# Key-only SSH for tomas. Turn password auth off only after a listed key has
# been proven to log in, so a switch can't lock anyone out. FileVault pre-boot unlock is a
# separate sshd and keeps taking the password.
{ config, ... }:
let
  username = config.system.primaryUser;
  authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPB/65/4O531Sfr7svHTIkykIHUIEPSMkKCrAcN81XAY tomas@yoga"
  ];
  passwordAuth = false;
in
{
  services.openssh = {
    enable = true;
    extraConfig = ''
      AllowUsers ${username}
      PasswordAuthentication ${if passwordAuth then "yes" else "no"}
      KbdInteractiveAuthentication ${if passwordAuth then "yes" else "no"}
    '';
  };

  users.users.${username}.openssh.authorizedKeys.keys = authorizedKeys;
}
