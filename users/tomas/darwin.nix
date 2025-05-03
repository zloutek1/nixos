{ pkgs, lib, username, ... }: {

  users.users.${username} = {
    name = username;
    home = lib.getHomeDirectory { inherit pkgs username; };
  };

}