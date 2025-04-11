{ config, ... }: {

  programs.zsh = {
    enable = true; 
    enableCompletion = true;
    autosuggestion.enable = true;
    dotDir = "./config/zsh";

    shellAliases = {
      ls = "ls -a --color=auto";
      ll = "ls -lah";
      grep = "grep --color=auto";
      ".." = "cd ..";
      "..." = "cd ../..";
      nix-switch = "sudo nixos-rebuild switch --flake ~/.config/nix";
      hm-switch = "home-manager switch --flake ~/.config/nix";
      sudo = "nocorrect sudo ";         # Handle sudo + alias expansion + correction
    };

    initExtra = ''
      # Load promptinit functions (optional but good practice)
      autoload -U promptinit && promptinit

      # Set the custom prompt string
      PROMPT='%f[%F{33}%c%f]%F{33}%# %f'

      # Optionally unset RPROMPT if a theme or plugin set one
      # RPROMPT=""
    '';
  };

}