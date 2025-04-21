{ pkgs, lib, users, ... }: {

  users.users = lib.listToAttrs (map (username: {
    name = username;
    value = {
      isNormalUser = true;
      description = username;
      extraGroups = [ "wheel" "networkmanager" "video" ];
      shell = pkgs.zsh;
    };
  }) users);

  environment.shells = with pkgs; [
    bash
    zsh
  ];

  programs.zsh.enable = true;

}