{
  pkgs,
  self,
  username,
  ...
}:
{

  imports = with self.homeModules; [
    cursor
    dark-theme
    xdg
    zsh
    zoxide
    git
  ];

  home.username = username;
  home.homeDirectory = self.lib.getHomeDirectory { inherit pkgs username; };
  home.stateVersion = "24.11";

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
