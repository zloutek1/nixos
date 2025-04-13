{
  pkgs,
  self,
  username,
  inputs,
  ...
}:
{

  imports = [
    inputs.nvchad4nix.homeManagerModule
    self.homeModules.cursor
    self.homeModules.dark-theme
    self.homeModules.xdg
    self.homeModules.zsh
    self.homeModules.zoxide
    self.homeModules.git
    self.homeModules.kitty
    self.homeModules.nvim
  ];

  home.username = username;
  home.homeDirectory = self.lib.getHomeDirectory { inherit pkgs username; };
  home.stateVersion = "24.11";

  programs.nvchad.enable = true;
  
  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Enable numlock
  xsession.numlock.enable = true;

  home.packages = with pkgs; [
    # Applications
    chromium
    obsidian

    # Coding
    vscode
  ];

}
