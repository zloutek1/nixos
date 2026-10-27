{ username, ... }:
let
  identity = import ./identity.nix;
in
{

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  # No home-manager on darwin, so git config is system-wide.
  environment.etc."gitconfig".text = ''
    [user]
      name = ${identity.name}
      email = ${identity.email}
    [init]
      defaultBranch = main
    [pull]
      rebase = true
  '';

}
