{ pkgs, ... }:
{

  fonts = {
    enableDefaultPackages = true;
    fontconfig.enable = true;

    packages = with pkgs; [
      jetbrains-mono
      nerd-font-patcher
      noto-fonts-color-emoji
    ];
  };

}
