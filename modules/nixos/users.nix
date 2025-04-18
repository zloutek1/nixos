{ username, pkgs, ... }: {

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "wheel" "networkmanager" "video" ];
    shell = pkgs.zsh;
  };

  environment.shells = with pkgs; [
    bash
    zsh
  ];

  programs.zsh.enable = true;

}