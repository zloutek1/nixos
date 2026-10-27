# A thin system-wide shell profile instead of home-manager.
{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    promptInit = ''
      PROMPT='%F{blue}%n@%m%f %F{yellow}%~%f %# '
    '';
    interactiveShellInit = ''
      HISTSIZE=50000
      SAVEHIST=50000
      setopt HIST_IGNORE_DUPS SHARE_HISTORY
      eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
    '';
  };

  environment.shellAliases = {
    ll = "ls -lah";
    rebuild = "sudo darwin-rebuild switch";
  };

  environment.systemPackages = [ pkgs.zoxide ];

  environment.variables.EDITOR = "nvim";
}
