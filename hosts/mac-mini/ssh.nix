# Key-only SSH for tomas. Password auth stays on until a key is listed below,
# so the first switch can't lock anyone out. FileVault pre-boot unlock is a
# separate sshd and keeps taking the password.
{ lib, username, ... }:
let
  authorizedKeys = [
    # Yoga
  ];
  passwordAuth = authorizedKeys == [ ];
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
