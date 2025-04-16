{ pkgs, ... }:
{

  fonts = {
    enableDefaultPackages = true;
    fontconfig.enable = true;

    packages = with pkgs; [
      jetbrains-mono
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      nerd-font-patcher
      noto-fonts-color-emoji
    ];
  };

}
