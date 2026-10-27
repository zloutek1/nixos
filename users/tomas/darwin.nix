{ pkgs, username, ... }:
let
  identity = import ./identity.nix;
in
{

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  # No home-manager on darwin, so git config is system-wide.
  # Nix's git reads the gitconfig in its own store path, not /etc/gitconfig.
  environment.variables.GIT_CONFIG_SYSTEM = "/etc/gitconfig";

  environment.etc."gitconfig".text = ''
    [user]
      name = ${identity.name}
      email = ${identity.email}
    [init]
      defaultBranch = main
    [pull]
      rebase = true
    [credential "https://github.com"]
      helper =
      helper = !${pkgs.gh}/bin/gh auth git-credential
  '';

}
