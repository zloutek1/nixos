{ pkgs, lib, username, ... }: {

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "wheel" "networkmanager" "video" ];
    shell = pkgs.zsh;
    hashedPassword = "$6$PdrZNYAaiJjGTBbJ$Gp2lZ6Vkh5GsYawp0nGtPxCeVu/wJLDjT2dH3O0kfI5mjpmrMtOmk.RgTcNjp/RHP3YsQDoz1TWUbYfZDLdMv1";
  };
  
  environment.shells = with pkgs; [
    bash
    zsh
  ];

  programs.zsh.enable = true;

}