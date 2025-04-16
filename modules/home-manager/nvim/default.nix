{ inputs, pkgs, lib, ... }: {

  imports = [
    inputs.nvchad4nix.homeManagerModule
  ];

  home.file.".config/nvim/lua/custom/kitty_padding.lua" = {
    source =./kitty_padding.lua;
  };

  programs.nvchad = {
    enable = true;
    hm-activation = true;
    backup = false;

    extraConfig = ''
      require('custom.kitty_padding')
    '';

    chadrcConfig = ''
      local M = {}
      
      M.base46 = {
        theme = "custom",
      }
      
      return M
    '';
  };

  home.activation.writeNvimTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f $HOME/.config/nvim/lua/themes/custom.lua ]; then
      mkdir -p "$HOME/.config/nvim/lua/themes"
      cat "${./theme.lua}" > "$HOME/.config/nvim/lua/themes/custom.lua"
    fi
  '';

  # IMPORTANT: Ensure standard neovim module is disabled
  programs.neovim.enable = false;

}